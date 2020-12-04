//
//  ViewController.swift
//  NiceAlert
//
//  Created by iya on 12/01/2020.
//  Copyright (c) 2020 iya. All rights reserved.
//

import UIKit
import NiceAlert

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert(_ sender: Any) {
        var provider = DefaultBackgroundProvider()
        provider.dimming = .view(UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)))
        let alert = ActionSheet(title: "Test title", backgroundProvider: provider)
        let cancel = Action(.title("Cancel"), style: .cancel) { (action) in
            print(action)
        }
        let ok = Action(.title("OK"), style: .default) { (action) in
            print(action)
        }
        alert.add(actions: [ok, cancel])
        alert.show(in: view)
    }
    
}

