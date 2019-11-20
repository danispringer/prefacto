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
            Constants.UserDef.selectedIcon: 0])

        // TODO: maybe needed to write similar tableview/navigation code
        //let tabar = UITabar.appearance()
//        UIView.appearance(
//            whenContainedInInstancesOf: [
//                UITabarController.self]).tintColor = UIColor(named: Constants.View.specialButtonColor)
        UINavigationBar.appearance().tintColor = UIColor(named: Constants.View.specialButtonColor)
        UIView.appearance(
            whenContainedInInstancesOf: [
                UIAlertController.self]).tintColor = UIColor(named: Constants.View.specialButtonColor)
        UIView.appearance(
            whenContainedInInstancesOf: [
                UIToolbar.self]).tintColor = UIColor(named: Constants.View.specialButtonColor)

        UIButton.appearance().tintColor = UIColor(named: Constants.View.specialButtonColor)

        UISwitch.appearance().onTintColor = UIColor(named: Constants.View.specialSwitchColor)

        for state: UIControl.State in [.application, .highlighted, .normal, .selected] {
            UIBarButtonItem.appearance().setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor(
                    named: Constants.View.specialButtonColor)!
            ], for: state)
        }


        return true
    }


    // MARK: Shortcuts

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        // TODO: fix for nav
        
        let navC = window?.rootViewController as? UINavigationController
        let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)
        let randomVC = (storyboard.instantiateViewController(
            withIdentifier: Constants.StoryboardID.random) as? RandomViewController)!
        navC?.pushViewController(randomVC, animated: false)
        randomVC.makeRandomShortcut()

        return true
    }

}
