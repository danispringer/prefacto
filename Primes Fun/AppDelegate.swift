//
//  AppDelegate.swift
//  Primes Fun
//
//  Created by Dani Springer on 19/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    var window: UIWindow?

    // Helpers
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let tabBar = UITabBar.appearance()
        tabBar.backgroundImage = UIImage.from(color: .clear)
        tabBar.shadowImage = UIImage.from(color: .clear)
        
        UITableView.appearance().backgroundColor = UIColor(red: 0.00, green: 0.16, blue: 0.21, alpha: 1.0)
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedStringKey.font : UIFont(name: "AmericanTypewriter", size: 20)!,
                //NSAttributedStringKey.foregroundColor : view.tintColor,
            ], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedStringKey.font : UIFont(name: "AmericanTypewriter", size: 20)!,
                //NSAttributedStringKey.foregroundColor : view.tintColor,
            ], for: .selected)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedStringKey.font : UIFont(name: "AmericanTypewriter", size: 20)!,
                //NSAttributedStringKey.foregroundColor : view.tintColor,
                ], for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedStringKey.font : UIFont(name: "AmericanTypewriter", size: 20)!,
                //NSAttributedStringKey.foregroundColor : view.tintColor,
            ], for: .disabled)

        
        return true
    }
    
    
}

