//
//  AppDelegate.swift
//  Prefacto
//
//  Created by Daniel Springer on 19/06/2018.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    // MARK: Properties

    var window: UIWindow?

    var launchedShortcutItem: UIApplicationShortcutItem?


    // Life Cycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
            UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

                if CommandLine.arguments.contains("--prefactoScreenshots") {
                    // We are in testing mode, make arrangements if needed
                    UIView.setAnimationsEnabled(false)
                }

                if let shortcutItem = launchOptions?[
                    UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {

                    launchedShortcutItem = shortcutItem
                    _ = makeRandomAndReturnDidWork()
                    // Since, the app launch is triggered by QuicAction, block
                    // "performActionForShortcutItem:completionHandler"
                    // method from being called.
                    return false
                }

                return true
            }


    // MARK: long press app icon OR Siri Shortcut

    fileprivate func makeRandomAndReturnDidWork() -> Bool {
        guard let safeNavVC = window?.rootViewController as? UINavigationController else {
            return false
        }

        safeNavVC.popToRootViewController(animated: false)
        let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)
        let randomVC: RandomViewController = (storyboard.instantiateViewController(
            withIdentifier: Const.StoryboardID.random) as! RandomViewController)
        safeNavVC.pushViewController(randomVC, animated: false)
        randomVC.makeRandomShortcut()
        return true
    }


    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {

        _ = makeRandomAndReturnDidWork()
    }


    // MARK: Shortcuts

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        makeRandomAndReturnDidWork()
    }

}
