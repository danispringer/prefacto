//
//  AppDelegate.swift
//  Prime
//
//  Created by Daniel Springer on 19/06/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    // MARK: Properties

    var window: UIWindow?


    // Life Cycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
        UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        UserDefaults.standard.register(defaults: [
            Constants.UserDef.showSeparator: false,
            Constants.UserDef.iconIsDark: true])

        let tabBar = UITabBar.appearance()
        tabBar.clipsToBounds = true
        tabBar.unselectedItemTintColor = UIColor.systemGray
        UIView.appearance(
            whenContainedInInstancesOf: [
                UIAlertController.self]).tintColor = UIColor(named: Constants.View.specialButtonColor)
        UIView.appearance(
            whenContainedInInstancesOf: [
                UITabBarController.self]).tintColor = UIColor(named: Constants.View.specialButtonColor)
        UIView.appearance(
            whenContainedInInstancesOf: [
                UIToolbar.self]).tintColor = UIColor(named: Constants.View.specialButtonColor)
        UISwitch.appearance().onTintColor = UIColor(named: Constants.View.specialButtonColor)

        for state: UIControl.State in [.normal, .selected, .highlighted, .disabled] {
            UIBarButtonItem.appearance().setTitleTextAttributes(
                [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)
                ], for: state)
        }

        return true
    }


    // MARK: Shortcuts

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        let tab = window?.rootViewController as? UITabBarController
        let randomVC = tab?.viewControllers?[3] as? RandomViewController
        randomVC?.makeRandomShortcut()
        tab?.selectedViewController = tab?.viewControllers?[3]

        return true
    }

}
