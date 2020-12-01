//
//  ActionSheetView.swift
//  NiceAlert
//
//  Created by iya on 2020/12/1.
//

import UIKit

open class ActionSheetView: AlertContainer {
    public let contentView: UIView = UIView()
    public private(set) var title: String?
    
    public convenience init(title: String?) {
        self.init()
        self.title = title
    }
    
    open func add(action: AlertAction) {
        
    }
    
    open func add(actions: [AlertAction]) {
        
    }
    
    open func show(in view: UIView) {
        
    }
    
    open func dismiss(completion: (() -> Void)?) {
        
    }
}
