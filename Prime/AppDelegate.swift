//
//  AppDelegate.swift
//  Prime
//
//  Created by Daniel Springer on 19/06/2018.
//  Copyright © 2021 Daniel Springer. All rights reserved.
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

                return true
            }


    // MARK: Shortcuts

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        guard let safeNavVC = window?.rootViewController as? UINavigationController else {
            return false
        }

        safeNavVC.popToRootViewController(animated: false)
        let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)
        let randomVC = (storyboard.instantiateViewController(
            withIdentifier: Const.StoryboardID.random) as? RandomViewController)!
        safeNavVC.pushViewController(randomVC, animated: false)
        randomVC.makeRandomShortcut()

        return true
    }

}
