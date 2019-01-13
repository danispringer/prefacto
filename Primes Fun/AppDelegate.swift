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

        // Create notification object
        let center = UNUserNotificationCenter.current()

        // Set the delegate of the Notification to be AppDelegate file
        center.delegate = self

        // Create action allowing user to copy number from notification
        let copyAction = UNNotificationAction(identifier: "COPY_ACTION",
                                              title: "Copy",
                                              options: UNNotificationActionOptions(rawValue: 0))

        // Create category with a copy action
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

        // Access view controller containing function that generates random prime numbers
        let tab = window?.rootViewController as? UITabBarController
        let randomVC = tab?.viewControllers?[3] as? RandomViewController

        let content = UNMutableNotificationContent()
        content.title = "Your daily prime is:"

        // Set body to random prime, or 1 if returned value is nil
        content.body = "\(randomVC?.makeRandomNotification() ?? 1)"

        content.categoryIdentifier = "RANDOM"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "choo.caf"))

        var date = DateComponents()
        date.hour = 9
        date.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        // For testing: comment out date and uncomment this manual trigger:
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: "RANDOM", content: content, trigger: trigger)

        center.add(request)

        /*
         TODO:
         1. clear all pending notifications

         2. get current date and time
         3. schedule 64 notifications for: current date at 9 AM, then add 1 to date
         */

        // 1
        center.removeAllPendingNotificationRequests()

        // 2
        let currentDate = Date()
        print(currentDate)

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

}
