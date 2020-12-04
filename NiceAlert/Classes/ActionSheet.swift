//
//  ActionSheet.swift
//  NiceAlert
//
//  Created by iya on 2020/12/1.
//

import UIKit
import SnapKit

open class ActionSheet {
    public let contentView = UIView()
    public private(set) var backgroundProvider: BackgroundProvider?
    public private(set) var customView: UIView?
    public private(set) var title: String?
    private var actions: [Action] = []
    private let backgroundView = BackgroundView()
    private var holder: AnyObject?
    
    public convenience init(title: String? = nil,
                            customView: UIView? = nil,
                            backgroundProvider: BackgroundProvider? = nil) {
        self.init()
        self.title = title
        self.customView = customView
        self.backgroundProvider = backgroundProvider
        
        if backgroundProvider?.allowDismissOnBackgroundTouch ?? false {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            backgroundView.addGestureRecognizer(tap)
        }
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    init() {
        backgroundView.willRemoveHandler = { [weak self] in
            self?.backgroundView.alert = nil
            self?.actions.forEach { $0.alert = nil }
            self?.backgroundView.subviews.forEach { $0.removeFromSuperview() }
        }
    }
    
    @objc private func handleTap() {
        dismiss()
    }
}


extension ActionSheet: Container {
    
    open func add(action: Action) {
        self.actions.append(action)
    }
    
    open func add(actions: [Action]) {
        self.actions.append(contentsOf: actions)
    }
    
    open func show(in view: UIView) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        var dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        if let provider = backgroundProvider {
            switch provider.dimming {
            case .color(let color): dimmingView.backgroundColor = color
            case .view(let view): dimmingView = view
            }
        }
        let dimmingViewAlpha = dimmingView.alpha
        dimmingView.isUserInteractionEnabled = false
        dimmingView.alpha = 0
        dimmingView.tag = "dimming".hash
        backgroundView.addSubview(dimmingView)
        dimmingView.snp.makeConstraints { $0.edges.equalToSuperview() }
        backgroundView.layoutIfNeeded()
        
        buildContents()
        backgroundView.addSubview(contentView)
        contentView.snp.makeConstraints {
            let width = min(view.bounds.width, backgroundView.bounds.height)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(width - 32)
            $0.bottom.equalTo(backgroundView.safeAreaLayoutGuide).offset(-16)
        }
        
        let height = backgroundView.bounds.height - contentView.frame.minY
        contentView.transform = CGAffineTransform(translationX: 0, y: height)
        
        let timing = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: 0.35, timingParameters: timing)
        animator.addAnimations { [unowned self] in
            self.contentView.transform = .identity
            dimmingView.alpha = dimmingViewAlpha
        }
        backgroundView.alert = self
        actions.forEach { $0.alert = self }
        animator.startAnimation()
    }
    
    open func dismiss(completion: (() -> Void)? = nil) {
        backgroundView.layoutIfNeeded()
        let dimmingView = backgroundView.viewWithTag("dimming".hash)
        let height = backgroundView.bounds.height - contentView.frame.minY
        
        let timing = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: 0.35, timingParameters: timing)
        animator.addAnimations { [unowned self] in
            self.contentView.transform = CGAffineTransform(translationX: 0, y: height)
            dimmingView?.alpha = 0
        }
        animator.addCompletion { [unowned self] (pos) in
            if pos == .end {
                completion?()
                self.backgroundView.removeFromSuperview()
            }
        }
        animator.startAnimation()
    }
    
    private func buildContents() {
        let topStackView = UIStackView()
        topStackView.axis = .vertical
        topStackView.spacing = 0
        topStackView.layer.cornerRadius = 16
        topStackView.clipsToBounds = true
        
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.black
            
            let titleContainerView = UIView()
            titleContainerView.backgroundColor = UIColor.white
            titleContainerView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.edges.equalTo(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
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
        stackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(topStackView)
        
        actions.forEach { (action) in
            let actionButton = ActionButton(type: .system)
            if case let Action.Content.title(title) = action.content {
                actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                actionButton.setTitle(title, for: .normal)
                actionButton.setTitleColor(action.style.color, for: .normal)
                actionButton.backgroundColor = .white
                actionButton.layer.cornerRadius = 16
                actionButton.addTarget(self, action: #selector(handleActionButtonTouchUp(_:)), for: .touchUpInside)
                actionButton.action = action
                actionButton.isEnabled = action.isEnabled
                actionButton.tag = action.hashValue
            }
            
            stackView.addArrangedSubview(actionButton)
            actionButton.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func handleActionButtonTouchUp(_ sender: ActionButton) {
        guard let action = sender.action else {
            return
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        action.handler?(action)
        if action.allowAutoDismiss || action.style == .cancel {
            dismiss()
        }
    }
}
