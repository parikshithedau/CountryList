//
//  AppDelegate.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 13.0, *) {
            
            // Always adopt a light interface style.
            window?.overrideUserInterfaceStyle = .light
        }
        
        // Reachability Observer
        PHReachability.shared.startObserver()
        
        return true
    }

}

