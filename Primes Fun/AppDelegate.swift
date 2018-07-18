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

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Default color of UITabBar background
        UITabBar.appearance().barTintColor = UIColor(red: 0.00, green: 0.16, blue: 0.21, alpha: 1.0) // dark blue
        
        // Default color of icon of selected UITabBarItem and Title
        UITabBar.appearance().tintColor = UIColor(red:0.93, green:0.90, blue:0.94, alpha:1.0) // off white
        //UITabBar.appearance().backgroundColor = UIColor.red // does nothing?
        
        UITableView.appearance().backgroundColor = UIColor(red: 0.00, green: 0.16, blue: 0.21, alpha: 1.0)
        UITableView.appearance()
        
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

