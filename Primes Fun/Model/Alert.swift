//
//  Alert.swift
//  Primes Fun
//
//  Created by Daniel Springer on 20/06/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit


extension UIViewController {


    enum AlertReason {
        case textfieldEmpty
        case network
        case notNumberOrTooBig
        case zero
        case one
        case two
        case negative
        case sameTwice
        case noPrimesInRange
        case messageSaved
        case messageCanceled
        case messageFailed
        case messageSent
        case unknown
        case noError
    }


    func createAlert(alertReasonParam: AlertReason, num: Int64 = 0, divisibleBy: Int64 = 0,
                     firstNum: Int64 = 0, secondNum: Int64 = 0) -> UIAlertController {
        var alertTitle = ""
        var alertMessage = ""
        switch alertReasonParam {
        case .network:
            alertTitle = "Network error"
            alertMessage = "Please check your network connection"
        case .textfieldEmpty:
            alertTitle = "Textfield empty"
            alertMessage = "Please enter a number."
        case .notNumberOrTooBig:
            alertTitle = "Invalid entry"
            alertMessage = """
            No text allowed.
            No spaces allowed.
            Only numbers.
            Max number: 9223372036854775807
            (2^63 − 1)
            """
        case .zero:
            alertTitle = "0 not allowed here"
            alertMessage = """
            Please enter a different number.
            """
        case .one:
            alertTitle = "1 not allowed here"
            alertMessage = """
            Please enter a different number.
            """
        case .negative:
            alertTitle = "Negative numbers not allowed here"
            alertMessage = """
            Please enter a different number.
            """
        case .sameTwice:
            alertTitle = "Same number entered twice"
            alertMessage = """
            Please enter two different numbers. To check if a single number is prime, use Checker.
            """
        case .messageSaved:
            alertTitle = "Message saved"
            alertMessage = "Message saved to drafts."
        case .messageCanceled:
            alertTitle = "Action cancelled"
            alertMessage = "Message not sent."
        case .messageFailed:
            alertTitle = "Action failed"
            alertMessage = """
            Message not sent. Please try again later, or contact us by leaving a review.
            """
        case .messageSent:
            alertTitle = "Success!"
            alertMessage = "Message sent. You should hear from us within 24 working hours."
        default:
            alertTitle = "Unknown error"
            alertMessage = """
            An unknown error occurred. Please try again later, or contact us by leaving a review.
            """
        }
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        return alert
    }


}
