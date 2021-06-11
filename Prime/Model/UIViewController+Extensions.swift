//
//  Alert.swift
//  Prime
//
//  Created by Daniel Springer on 20/06/2018.
//  Copyright © 2021 Daniel Springer. All rights reserved.
//

import UIKit


extension UIViewController {

    enum AlertReason {
        case textfieldEmpty
        case notNumberOrTooBig
        case overflow
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
    }


    func createAlert(alertReasonParam: AlertReason, num: Int64 = 0) -> UIAlertController {
        var alertTitle = ""
        var alertMessage = ""
        switch alertReasonParam {
        case .textfieldEmpty:
            alertTitle = "Textfield empty"
            alertMessage = "Please enter a number."
        case .notNumberOrTooBig:
            alertTitle = "Invalid entry"
            alertMessage = """
                Only numbers allowed. No decimals.
                Max number: 9223372036854775807
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
        case .two:
            alertTitle = "2 not allowed here"
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
                Please enter two different numbers. To check if a single number is prime, use Check.
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
            alertMessage = "Message sent. You should hear from us within 24 hours."
        case .overflow:
            alertTitle = "Overflow"
            alertMessage = """
                There are no primes above \(num) which are lower than 9223372036854775807 \
                (your device's limit)
                """
        default:
            alertTitle = "Unknown error"
            alertMessage = """
                An unknown error occurred. Please try again later, or contact us at dani.springer@icloud.com
                """
        }
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        return alert
    }


}
