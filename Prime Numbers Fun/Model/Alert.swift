//
//  Alert.swift
//  Prime Numbers Fun
//
//  Created by Dani Springer on 20/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static var shared = Alert()

    enum alertReason: String {
        case textfieldEmpty = "textfieldEmpty"
        case network = "network"
        case notNumberOrTooBig = "notNumberOrTooBig"
        case zero = "zero"
        case one = "one"
        case two = "two"
        case negative = "negative"
        case prime = "prime"
        case notPrime = "notPrime"
        case unknown = "unknown"
    }

    func createAlert(alertReasonParam: String, num: Int64 = 0, divisibleBy: Int64 = 0) -> UIAlertController {
        
        var alertTitle = ""
        var alertMessage = ""
        switch alertReasonParam {
        case alertReason.network.rawValue:
            alertTitle = "Network error"
            alertMessage = "Please check your network connection and try again."
        case alertReason.textfieldEmpty.rawValue:
            alertTitle = "Oops"
            alertMessage = "Textfield is empty. Please enter a number and try again."
        case alertReason.notNumberOrTooBig.rawValue:
            alertTitle = "Oops"
            alertMessage = "No text allowed. Just numbers.\nMax number: 9223372036854775807\nOr (2^63 − 1)"
        case alertReason.zero.rawValue:
            alertTitle = "Hmm..."
            alertMessage = "Is 0 prime? Nobody knows! Please enter a different number."
        case alertReason.one.rawValue:
            alertTitle = "Hmm..."
            alertMessage = "Is 1 prime? Nobody knows! Please enter a different number."
        case alertReason.two.rawValue:
            alertTitle = "Prime"
            alertMessage = "2 is a prime number!"
        case alertReason.negative.rawValue:
            alertTitle = "Don't be negative"
            alertMessage = "Negative numbers cannot be prime. Please enter a different number."
        case alertReason.prime.rawValue:
            alertTitle = "Prime"
            alertMessage = "\(num) is a prime number!"
        case alertReason.notPrime.rawValue:
            alertTitle = "Not prime"
            alertMessage = "\(num) is not a prime number.\nIs it divisible by \(divisibleBy)."
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
