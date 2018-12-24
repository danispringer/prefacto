//
//  AppDelegate.swift
//  Primes Fun
//
//  Created by Daniel Springer on 19/06/2018.
//  Copyright © 2018 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    // MARK: Properties

    var window: UIWindow?
    let dataController = DataController(modelName: Constants.Model.name)


    // Life Cycle

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        dataController.load()
        let tab = window?.rootViewController as? UITabBarController
        let photosVC = tab?.viewControllers?.last as? PhotosViewController
        photosVC?.dataController = dataController
        UserDefaults.standard.register(defaults: [Constants.UserDefaultsStrings.soundEnabled: true])
        let tabBar = UITabBar.appearance()
        tabBar.backgroundImage = UIImage.from(color: .clear)
        tabBar.shadowImage = UIImage.from(color: .clear)
        tabBar.tintColor = Constants.View.goldColor
        tabBar.unselectedItemTintColor = Constants.View.grayColor
        UIToolbar.appearance().tintColor = Constants.View.goldColor
        UIToolbar.appearance().barTintColor = .black
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().backgroundColor = Constants.View.goldColor
        UINavigationBar.appearance().isOpaque = false
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = Constants.View.goldColor
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: Constants.Font.AmericanTypewriter, size: 20)!
            ], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: Constants.Font.AmericanTypewriter, size: 20)!
            ], for: .selected)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: Constants.Font.AmericanTypewriter, size: 20)!
            ], for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: Constants.Font.AmericanTypewriter, size: 20)!,
                NSAttributedString.Key.foregroundColor: Constants.View.grayColor
            ], for: .disabled)
        return true
    }


    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        let viewController = window?.rootViewController as? RandomViewController
        viewController?.makeRandomShortcut()

        let tab = window?.rootViewController as? UITabBarController
        let randomVC = tab?.viewControllers?[3] as? RandomViewController
        randomVC?.makeRandomShortcut()

        return true
    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        /*
         Use this method to release shared resources, save user data,
         invalidate timers, and store enough application state information
         to restore your application to its current state in case it is
         terminated later.
         If your application supports background execution, this method is
         called instead of applicationWillTerminate: when the user quits.
         */
        saveViewContext()
    }


    func applicationWillTerminate(_ application: UIApplication) {
        /* Called when the application is about to terminate.
         Save data if appropriate. See also applicationDidEnterBackground:.
         */
        saveViewContext()
    }


    // MARK: Helpers

    func saveViewContext() {
        try? dataController.viewContext.save()
    }

}
