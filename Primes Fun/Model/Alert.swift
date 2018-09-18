//
//  Alert.swift
//  Primes Fun
//
//  Created by Dani Springer on 20/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit

extension UIViewController {

    enum alertReason {
        case textfieldEmpty
        case network
        case notNumberOrTooBig
        case zero
        case one
        case two
        case negative
        case prime
        case notPrime
        case sameTwice
        case noPrimesInRange
        case messageSaved
        case messageCanceled
        case messageFailed
        case messageSent
        case unknown
        case noError
    }

    func createAlert(alertReasonParam: alertReason, num: Int64 = 0, divisibleBy: Int64 = 0, firstNum: Int64 = 0, secondNum: Int64 = 0) -> UIAlertController {
        
        var alertTitle = ""
        var alertMessage = ""
        switch alertReasonParam {
        case .network:
            alertTitle = "Network error"
            alertMessage = "Please check your network connection and try again."
        case .textfieldEmpty:
            alertTitle = "Oops"
            alertMessage = "Textfield is empty. Please enter a number and try again."
        case .notNumberOrTooBig:
            alertTitle = "Oops"
            alertMessage = "No text allowed. Just numbers.\nMax number: 9223372036854775807\nOr (2^63 − 1)"
        case .zero:
            alertTitle = "Oops"
            alertMessage = "It seems like you entered no value. Or actually, 0 value. Please enter a different number."
        case .one:
            alertTitle = "Hmm..."
            alertMessage = "Is 1 prime? Nobody knows! Please enter a different number."
        case .two:
            alertTitle = "Prime"
            alertMessage = "2 is a prime number!"
        case .negative:
            alertTitle = "Oops"
            alertMessage = "No negative numbers allowed. Please enter a different number."
        case .prime:
            alertTitle = "Prime"
            alertMessage = "\(num) is a prime number!"
        case .notPrime:
            alertTitle = "Not prime"
            alertMessage = "\(num) is not a prime number.\nIs it divisible by \(divisibleBy)."
        case .sameTwice:
            alertTitle = "Oops"
            alertMessage = "Cannot make a list from a single number. Please enter different numbers."
        case .noPrimesInRange:
            alertTitle = "Oops"
            alertMessage = "There are no prime numbers between '\(firstNum)' and '\(secondNum)'. Please enter different numbers."
        case .messageSaved:
            alertTitle = "Message saved"
            alertMessage = "Your message has been saved to drafts."
        case .messageCanceled:
            alertTitle = "Action cancelled"
            alertMessage = "Your message has not been sent."
        case .messageFailed:
            alertTitle = "Action failed"
            alertMessage = "Your message has not been sent. Please try again later, or contact us by visiting DaniSpringer.GitHub.io"
        case .messageSent:
            alertTitle = "Success!"
            alertMessage = "Your message has been sent. You should hear from us within 24 working hours."
        default:
            alertTitle = "Unknown error"
            alertMessage = "An unknown error occurred. Please try again later, or contact us by visiting DaniSpringer.GitHub.io"
        }
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        
        return alert
    }
}
