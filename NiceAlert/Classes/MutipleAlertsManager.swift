//
//  MutipleAlertsManager.swift
//  NiceAlert
//
//  Created by iya on 2020/12/1.
//

import Foundation


class MutipleAlertsManager {
    let shared = MutipleAlertsManager()
    let backgroundView = AlertBackgroundView()
    
    var alerts: [AlertContainer] = []
}
