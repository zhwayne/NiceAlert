//
//  BackgroundProvider.swift
//  NiceAlert
//
//  Created by iya on 2020/12/2.
//

import UIKit

public enum Dimming {
    case color(UIColor)
    case view(UIView)
}

public protocol BackgroundProvider {
    var dimming: Dimming { get set }
    var allowDismissOnBackgroundTouch: Bool { get set }
}

public struct DefaultBackgroundProvider: BackgroundProvider {
    public var dimming: Dimming = .color(UIColor.black.withAlphaComponent(0.3))
    public var allowDismissOnBackgroundTouch = false
    
    public init() {}
}
