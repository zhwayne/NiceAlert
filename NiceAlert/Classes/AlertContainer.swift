//
//  AlertContainer.swift
//  NiceAlert
//
//  Created by iya on 2020/12/1.
//

import UIKit

public protocol AlertContainer {
    var contentView: UIView { get }
}

extension AlertContainer {
    func add(action: AlertAction) {}
    func add(actions: [AlertAction]) {}
    
    func show(in view: UIView) {}
    func dismiss(completion: (() -> Void)? = nil) {}
}
