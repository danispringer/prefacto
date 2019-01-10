//
//  AppDelegate.swift
//  Primes Fun
//
//  Created by Daniel Springer on 19/06/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {


    // MARK: Properties

    var window: UIWindow?


    // Life Cycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
        UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        // MARK: Notification

        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let copyAction = UNNotificationAction(identifier: "COPY_ACTION",
                                              title: "Copy",
                                              options: UNNotificationActionOptions(rawValue: 0))

        let myCategory = UNNotificationCategory(identifier: "RANDOM",
                                                actions: [copyAction],
                                                intentIdentifiers: [],
                                                hiddenPreviewsBodyPlaceholder: "",
                                                options: .customDismissAction)

        center.setNotificationCategories([myCategory])

        let options: UNAuthorizationOptions = [.alert, .sound]

        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong: \(String(describing: error))")
            }
        }

        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }

        let tab = window?.rootViewController as? UITabBarController
        let randomVC = tab?.viewControllers?[3] as? RandomViewController

        let content = UNMutableNotificationContent()
        content.title = "Your daily prime is:"
        content.body = "\(randomVC?.makeRandomNotification() ?? 1)"
        content.categoryIdentifier = "RANDOM"

        /*
         TODO:
         - make notification work even if app is open
         */

        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "choo.caf"))


//        var date = DateComponents()
//        date.hour = 9
//        date.minute = 00
//        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        // For testing: comment out date and uncomment this manual trigger:
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        let request = UNNotificationRequest(identifier: "RANDOM", content: content, trigger: trigger)

        center.add(request)
        // end of notifications

        UserDefaults.standard.register(defaults: [
            Constants.UserDef.soundEnabled: true,
            Constants.UserDef.darkModeEnabled: true])

        let tabBar = UITabBar.appearance()
        tabBar.backgroundImage = UIImage.from(color: .clear)
        tabBar.shadowImage = UIImage.from(color: .clear)

        UINavigationBar.appearance().isOpaque = false
        UINavigationBar.appearance().isTranslucent = false

        for state: UIControl.State in [.normal, .selected, .highlighted] {
            UIBarButtonItem.appearance().setTitleTextAttributes(
                [
                    NSAttributedString.Key.font: UIFont(name: Constants.Font.math, size: 25)!
                ], for: state)
        }

        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: Constants.Font.math, size: 25)!,
                NSAttributedString.Key.foregroundColor: Constants.View.grayColor
            ], for: .disabled)

        return true
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "COPY_ACTION":
            UIPasteboard.general.string = response.notification.request.content.body
        default:
            break
        }
        completionHandler()
    }


    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .sound])
    }


    // MARK: Shortcuts

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        let tab = window?.rootViewController as? UITabBarController
        let randomVC = tab?.viewControllers?[3] as? RandomViewController
        randomVC?.makeRandomShortcut()


        return true
    }


}
