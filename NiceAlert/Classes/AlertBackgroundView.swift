//
//  AlertBackgroundView.swift
//  NiceAlert
//
//  Created by iya on 2020/12/1.
//

import UIKit


class AlertBackgroundView: UIView {
    var alert: AlertContainer?
    var willRemoveFromSuperView: (() -> Void)?
    
    override func willMove(toSuperview newSuperview: UIView?) {
        superview?.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            willRemoveFromSuperView?()
        }
    }
}
