//
//  AppDelegate.swift
//  Is It Prime
//
//  Created by Dani Springer on 19/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let dataController = DataController(modelName: "Model")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        dataController.load()
        
        let tabBarController = window?.rootViewController as! UITabBarController
        let checkerViewController = tabBarController.selectedViewController as! CheckerViewController
        checkerViewController.dataController = dataController
        
        return true
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
    
    func saveViewContext() {
        try? dataController.viewContext.save()
    }


}

