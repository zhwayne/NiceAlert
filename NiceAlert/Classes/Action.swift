//
//  Action.swift
//  NiceAlert
//
//  Created by iya on 2020/12/1.
//

import UIKit


public class Action {
    public typealias Handler = (_ action: Action) -> Void
    
    public let content: Content
    public let style: Style
    public let handler: Handler?
    
    public init(_ content: Content, style: Style = .default, handler: Handler? = nil) {
        self.content = content
        self.style = style
        self.handler = handler
    }
    
    public internal(set) var alert: Container?
    
    public var allowAutoDismiss = true
    
    public var isEnabled = true {
        didSet {
            if let button = alert?.contentView.viewWithTag(hashValue) as? ActionButton {
                button.isEnabled = isEnabled
            }
        }
    }
}

extension Action: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(content)
        hasher.combine(style)
    }
    
    public static func == (lhs: Action, rhs: Action) -> Bool {
        return lhs.content == rhs.content && lhs.style == rhs.style
    }
}

public extension Action {
    enum Content: Hashable {
        case title(String)
    }
}

public extension Action {
    enum Style: Hashable {
        case `default`
        case cancel
        case destructive
        case custom(color: UIColor)
    }
}


public protocol AlertActionStyleColor {}
extension Action.Style: AlertActionStyleColor {}

public extension AlertActionStyleColor where Self == Action.Style {
    var color: UIColor {
        switch self {
        case .default: return UIColor.systemTeal
        case .cancel: return UIColor.systemGray
        case .destructive: return UIColor.systemRed
        case .custom(color: let color): return color
        }
    }
}
