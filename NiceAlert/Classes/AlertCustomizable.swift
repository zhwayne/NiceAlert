//
//  AlertCustomizable.swift
//  NiceAlert
//
//  Created by iya on 2020/12/2.
//

import UIKit

public enum AlertDimming {
    case color(UIColor)
    case view(UIView)
}

public protocol AlertCustomizable {
    var dimming: AlertDimming { get }
    var allowDismissOnBackgroundTouch: Bool { get }
}

extension AlertCustomizable {
    var dimming: AlertDimming {
        return .color(UIColor.black.withAlphaComponent(0.5))
    }
    
    var allowDismissOnBackgroundTouch: Bool {
        return false
    }
}
