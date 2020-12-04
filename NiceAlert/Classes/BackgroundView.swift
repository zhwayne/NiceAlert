//
//  BackgroundView.swift
//  NiceAlert
//
//  Created by iya on 2020/12/1.
//

import UIKit


class BackgroundView: UIView {
    var alert: Container?
    var willRemoveHandler: (() -> Void)?
    
    override func willMove(toSuperview newSuperview: UIView?) {
        superview?.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            willRemoveHandler?()
        }
    }
}
