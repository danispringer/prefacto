//
//  Alert.swift
//  Is It Prime
//
//  Created by Dani Springer on 20/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static var shared = Alert()

    enum alertReason: String {
        case usernameOrPasswordEmpty = "usernameOrPasswordEmpty"
        case usernameOrPasswordInvalid = "usernameOrPasswordInvalid"
        case url = "url"
        case locationEmpty = "locationEmpty"
        case locationInvalid = "locationInvalid"
        case network = "network"
        case invalidURL = "invalidURL"
        case unknown = "unknown"
    }

    func createAlert(alertReasonParam: String) -> UIAlertController {
        
        var alertTitle = ""
        var alertMessage = ""
        switch alertReasonParam {
        case alertReason.usernameOrPasswordEmpty.rawValue:
            alertTitle = "Empty field"
            alertMessage = "Please enter your username and password and try again."
        case alertReason.usernameOrPasswordInvalid.rawValue:
            alertTitle = "Invalid credentials"
            alertMessage = "Please check your username and password and try again"
        case alertReason.url.rawValue:
            alertTitle = "Empty URL"
            alertMessage = "Please enter a URL."
        case alertReason.locationEmpty.rawValue:
            alertTitle = "Empty location"
            alertMessage = "Please enter a location."
        case alertReason.locationInvalid.rawValue:
            alertTitle = "Invalid location"
            alertMessage = "Please check your location and try again."
        case alertReason.network.rawValue:
            alertTitle = "Network error"
            alertMessage = "Please check your network connection and try again."
        case alertReason.invalidURL.rawValue:
            alertTitle = "Invalid URL"
            alertMessage = "Please check your URL and try again."
        default:
            alertTitle = "Unknown error"
            alertMessage = "An unknown error occurred. Please try again later."
        }
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        
        return alert
    }
}
