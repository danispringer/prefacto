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
    
    let dataController = DataController(modelName: "Model")

    // Helpers
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        dataController.load()
        
        let tab = window?.rootViewController as! UITabBarController
        let photosVC = tab.viewControllers?.last as! PhotosViewController
        photosVC.dataController = dataController
        
            
        UserDefaults.standard.register(defaults: ["soundEnabled": true])

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
    
    
    func saveViewContext() {
        try? dataController.viewContext.save()
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveViewContext()
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveViewContext()
    }
    
}

