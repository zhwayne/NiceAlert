//
//  ActionSheetView.swift
//  NiceAlert
//
//  Created by iya on 2020/12/1.
//

import UIKit
import SnapKit

open class ActionSheetView {
    public let contentView = UIView()
    public private(set) var customView: (UIView & AlertCustomizable)?
    public private(set) var title: String?
    private var actions: [AlertAction] = []
    private let backgroundView = AlertBackgroundView()
    
    public convenience init(title: String?, customView: (UIView & AlertCustomizable)? = nil) {
        self.init()
        self.title = title
        self.customView = customView
        
        if customView?.allowDismissOnBackgroundTouch ?? false {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            backgroundView.addGestureRecognizer(tap)
        }
    }
    
    @objc private func handleTap() {
        dismiss()
    }
}


extension ActionSheetView: AlertContainer {
    
    open func add(action: AlertAction) {
        self.actions.append(action)
    }
    
    open func add(actions: [AlertAction]) {
        self.actions.append(contentsOf: actions)
    }
    
    open func show(in view: UIView) {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        var dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        if let customView = customView {
            switch customView.dimming {
            case .color(let color): dimmingView.backgroundColor = color
            case .view(let view): dimmingView = view
            }
        }
        dimmingView.isUserInteractionEnabled = false
        backgroundView.addSubview(dimmingView)
        dimmingView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        buildContents()
        backgroundView.addSubview(contentView)
        contentView.snp.makeConstraints { $0.left.right.bottom.equalToSuperview() }
        
        backgroundView.layoutIfNeeded()
        let height = contentView.bounds.height
        contentView.transform = CGAffineTransform(translationX: 0, y: height)
        
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            self.contentView.transform = .identity
        }
        animator.startAnimation()
    }
    
    open func dismiss(completion: (() -> Void)? = nil) {
        backgroundView.layoutIfNeeded()
        let height = contentView.bounds.height
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: height)
        }
        animator.addCompletion { (postion) in
            if postion == .end {
                completion?()
            }
        }
        animator.startAnimation()
    }
    
    private func buildContents() {
        let topStackView = UIStackView()
        topStackView.axis = .vertical
        topStackView.spacing = 0
        topStackView.distribution = .fill
        
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel.numberOfLines = 0
            titleLabel.textColor = UIColor.black
            
            let titleContainerView = UIView()
            titleContainerView.backgroundColor = UIColor.white
            titleContainerView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.edges.equalTo(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
            }
            
            topStackView.addArrangedSubview(titleContainerView)
        }
        
        if let customView = customView {
            let customViewContainerView = UIView()
            customViewContainerView.addSubview(customView)
            customView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            topStackView.addArrangedSubview(customViewContainerView)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(topStackView)
        
        actions.forEach { (action) in
            let actionButton = ActionButton(type: .system)
            if case let AlertAction.Content.title(title) = action.content {
                actionButton.setTitle(title, for: .normal)
                actionButton.setTitleColor(action.style.color, for: .normal)
                actionButton.backgroundColor = .white
                actionButton.layer.cornerRadius = 15
                actionButton.addTarget(self, action: #selector(handleActionButtonTouchUp(_:)), for: .touchUpInside)
            }
            
            stackView.addArrangedSubview(actionButton)
            actionButton.snp.makeConstraints {
                $0.height.equalTo(44)
            }
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).priority(.medium)
        }
    }
    
    @objc private func handleActionButtonTouchUp(_ sender: ActionButton) {
        guard let action = sender.action else {
            return
        }
        action.handler?(action)
        if action.style == .cancel {
            dismiss()
        }
    }
}



class ActionButton : UIButton {
    var action: AlertAction?
}
