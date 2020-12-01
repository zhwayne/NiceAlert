//
//  Action.swift
//  NiceAlert
//
//  Created by iya on 2020/12/1.
//

import UIKit


public struct AlertAction {
    public typealias Handler = (_ action: Self) -> Void
    
    public let content: Content
    public let style: Style
    public let handler: Handler?
    
    public init(_ content: Content, style: Style = .default, handler: Handler? = nil) {
        self.content = content
        self.style = style
        self.handler = handler
    }
    
    public var host: AlertContainer?
    
    public var allowAutoDismiss = true
    
    public var isEnabled = true {
        didSet {
            
        }
    }
}

public extension AlertAction {
    enum Content {
        case title(String)
    }
}

public extension AlertAction {
    enum Style {
        case `default`
        case cancel
        case destructive
        case custom(color: UIColor)
    }
}
