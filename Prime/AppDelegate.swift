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

        UDStan.register(defaults: [
                            Const.UserDef.selectedTextField: 0,
                            Const.UserDef.numFromList: ""])

        UINavigationBar.appearance().tintColor = UIColor(named: Const.View.specialButtonColor)
        UIView.appearance(
            whenContainedInInstancesOf: [
                UIAlertController.self]).tintColor = UIColor(named: Const.View.specialButtonColor)
        UIView.appearance(
            whenContainedInInstancesOf: [
                UIToolbar.self]).tintColor = UIColor(named: Const.View.specialButtonColor)

        UIButton.appearance().tintColor = UIColor(named: Const.View.specialButtonColor)

        UISwitch.appearance().onTintColor = UIColor(named: Const.View.specialSwitchColor)

        for state: UIControl.State in [.application, .highlighted, .normal, .selected] {
            UIBarButtonItem.appearance().setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor(
                    named: Const.View.specialButtonColor)!
            ], for: state)
        }


        return true
    }


    // MARK: Shortcuts

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        let navC = window?.rootViewController as? UINavigationController
        navC?.popToRootViewController(animated: false)
        let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)
        let randomVC = (storyboard.instantiateViewController(
                            withIdentifier: Const.StoryboardID.random) as? RandomViewController)!
        navC?.pushViewController(randomVC, animated: false)
        randomVC.makeRandomShortcut()

        return true
    }


}
