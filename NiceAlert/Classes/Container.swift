//
//  Container.swift
//  NiceAlert
//
//  Created by iya on 2020/12/1.
//

import UIKit

public protocol Container {
    var contentView: UIView { get }
    var backgroundProvider: BackgroundProvider? { get }
}

extension Container {
    func add(action: Action) {}
    func add(actions: [Action]) {}
    
    func show(in view: UIView) {}
    func dismiss(completion: (() -> Void)? = nil) {}
}
