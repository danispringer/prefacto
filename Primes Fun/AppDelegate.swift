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

        let tab = window?.rootViewController as? UITabBarController
        let randomVC = tab?.viewControllers?[3] as? RandomViewController

        // MARK: Notification

        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.removeAllPendingNotificationRequests()

        let now = Date()
        let calendar = Calendar.current
        /*
         To test:
         let components = DateComponents(
             calendar: calendar,
             hour: CURRENT_HOUR,
             minute: CURRENT_MINUTE + 5)

         Production:


         */
        let components = DateComponents(calendar: calendar, hour: 11, weekday: 1)
        let nextSunday11AM = calendar.nextDate(
            after: now,
            matching: components,
            matchingPolicy: .nextTime)!

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

        center.requestAuthorization(options: options) { (granted, _) in

            guard granted else {
                return
            }

            for number in 0...63 {
                /*
                 To test:
                 let newDate = Calendar.current.date(byAdding: .second, value: (number * 10), to: nextSunday11AM)
                 Change range to 1...63

                 Production:
                 let newDate = Calendar.current.date(
                 byAdding: .day,
                 value: (number * 7),
                 to: nextSunday11AM)
                 Change range to 0...63
                 */
                let newDate = Calendar.current.date(
                    byAdding: .day,
                    value: (number * 7),
                    to: nextSunday11AM)
                let calendar = Calendar.current
                let components = DateComponents(
                    calendar: calendar,
                    year: calendar.component(.year, from: newDate!),
                    month: calendar.component(.month, from: newDate!),
                    day: calendar.component(.day, from: newDate!),
                    hour: calendar.component(.hour, from: newDate!),
                    minute: calendar.component(.minute, from: newDate!),
                    second: calendar.component(.second, from: newDate!))

                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

                let content = UNMutableNotificationContent()
                content.title = "Your weekly prime is:"
                content.body = "\(randomVC?.makeRandomNotification() ?? 1)"
                content.categoryIdentifier = "RANDOM-\(number)"

                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "choo.caf"))

                let request = UNNotificationRequest(
                    identifier: content.categoryIdentifier,
                    content: content,
                    trigger: trigger)
                center.add(request)
            }
        }

        center.getNotificationSettings { (settings) in

            guard settings.authorizationStatus == .authorized else {
                return
            }

        }

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
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)
                ], for: state)
        }

        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25),
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
