//
//  Alert.swift
//  Prefacto
//
//  Created by Daniel Springer on 20/06/2018.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit


extension UIViewController {

    enum AlertReason {
        case textfieldEmptyOne
        case textfieldEmptyTwo
        case textfieldEmptySingle
        case notNumberOrTooBig
        case overflow
        case higherThanZero
        case higherThanOne
        case sameTwice
        case noPrimesInRange
        case unknown
        case emailError
    }


    func createAlert(alertReasonParam: AlertReason, num: UInt64 = 0) -> UIAlertController {
        var alertTitle = ""
        var alertMessage = ""
        switch alertReasonParam {
            case .emailError:
                alertTitle = "Email Not Sent"
                alertMessage = """
                Your device could not send e-mail. Please check e-mail configuration and \
                try again.
                """
            case .textfieldEmptyOne:
                alertTitle = "Please enter your first number"
                alertMessage = "Then try again"
            case .textfieldEmptyTwo:
                alertTitle = "Please enter your second number"
                alertMessage = "Then try again"
            case .textfieldEmptySingle:
                alertTitle = "Please enter your number"
                alertMessage = "Then try again"
            case .notNumberOrTooBig:
                alertTitle = "Please enter numbers only"
                alertMessage = """
                Highest number allowed: \(UInt64.max)
                """
            case .higherThanZero:
                alertTitle = "Please enter a positive number"
                alertMessage = """
                Please enter a number higher than 0
                """
            case .higherThanOne:
                alertTitle = "Please enter 2 or higher"
                alertMessage = """
                Since 1 is the first prime, there is no "previous" prime for it.
                """
            case .sameTwice:
                alertTitle = "Same number entered twice"
                alertMessage = """
                Please enter two different numbers. To check if a single number is prime, \
                use Check
                """
            case .overflow:
                alertTitle = "Please enter a lower number"
                alertMessage = """
                There are no primes above \(num) which are lower than \(UInt64.max) \
                (your device's limit)
                """
            default:
                alertTitle = "Unknown error"
                alertMessage = """
                An unknown error occurred. Please try again.
                """
        }
        let alert = UIAlertController(title: alertTitle, message: alertMessage,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            notif.post(name: .tryShowingKeyboard, object: nil, userInfo: nil)
        }
        alert.addAction(alertAction)
        return alert
    }


    func setThemeColorTo(myThemeColor: UIColor) {
        self.navigationController?.navigationBar.tintColor = myThemeColor
        UINavigationBar.appearance().tintColor = myThemeColor
        UIView.appearance(
            whenContainedInInstancesOf: [
                UIAlertController.self]).tintColor = myThemeColor
        UIView.appearance(
            whenContainedInInstancesOf: [
                UIToolbar.self]).tintColor = myThemeColor

        UIButton.appearance().tintColor = myThemeColor

        UISwitch.appearance().onTintColor = myThemeColor

        for state: UIControl.State in [.application, .highlighted, .normal, .selected] {
            UIBarButtonItem.appearance().setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: myThemeColor
            ], for: state)
        }
    }


    // MARK: Many

    func manyPrimesInRangeShare(localFrom: UInt64, localTo: UInt64,
                                localSource: [UInt64]) -> String {

        guard localSource.count > 0 else {
            return """
            There are no primes between
            \(localFrom)
            and
            \(localTo)
            """
        }

        return """
        There are \(localSource.count) prime numbers from
        \(localFrom)
        to
        \(localTo)
        They are:
        \(localSource)
        """
    }


    // MARK: Is Prime

    func isPrimeMessage(localNumber: UInt64, color: UIColor) -> NSMutableAttributedString {
        let aString = attrifyString(preString: "Value:", toAttrify: "\(localNumber)",
                                    color: color)
        aString.append(attrifyString(preString: "Prime:", toAttrify: "Yes", color: color))
        return aString
    }


    func isPrimeMessageShare(localNumber: UInt64) -> String {
        let aString = "The number \(localNumber) is prime"
        return aString
    }


    // MARK: Is Not Prime

    func isNotPrimeMessage(localNumber: UInt64, localIsDivisibleBy: UInt64,
                           color: UIColor) -> NSMutableAttributedString {
        let aString = attrifyString(preString: "Value:", toAttrify: "\(localNumber)",
                                    color: color)
        aString.append(attrifyString(preString: "Prime:", toAttrify: "No", color: color))
        aString.append(attrifyString(preString: "Factor:",
                                     toAttrify: "\(localIsDivisibleBy)", color: color))
        return aString
    }


    func isNotPrimeMessageShare(localNumber: UInt64, localIsDivisibleBy: UInt64) -> String {
        return """
        The number \(localNumber) is not prime, as it divides by \(localIsDivisibleBy)
        """
    }


    // MARK: Many Factors

    func manyPrimeFactorsShare(localNumber: UInt64, localSource: [String]) -> String {
        let localSourceCleaned = localSource.joined(separator: ", ")
            .replacingOccurrences(of: "\"", with: "")
        return """
        The number \(localNumber) has \(localSource.count) factors
        They are: \(localSourceCleaned)
        """
    }


    // MARK: Next

    func nextPrimeMessage(localOriginalNumber: UInt64, localNextPrime: UInt64,
                          color: UIColor) -> NSMutableAttributedString {
        let aString = attrifyString(preString: "Value:",
                                    toAttrify: "\(localOriginalNumber)", color: color)
        aString.append(attrifyString(preString: "Next prime:",
                                     toAttrify: "\(localNextPrime)", color: color))
        return aString
    }


    func nextPrimeMessageShare(localOriginalNumber: UInt64, localNextPrime: UInt64) -> String {
        return """
        The next prime above \(localOriginalNumber) is \(localNextPrime)
        """
    }


    // MARK: Previous

    func previousPrimeMessage(localOriginalNumber: UInt64, localPreviousPrime: UInt64,
                              color: UIColor) -> NSMutableAttributedString {
        let aString = attrifyString(preString: "Value:",
                                    toAttrify: "\(localOriginalNumber)", color: color)
        aString.append(attrifyString(preString: "Previous prime:",
                                     toAttrify: "\(localPreviousPrime)", color: color))
        return aString
    }


    func previousPrimeMessageShare(localOriginalNumber: UInt64,
                                   localPreviousPrime: UInt64) -> String {
        return """
        The previous prime below \(localOriginalNumber) is \(localPreviousPrime)
        """
    }


    func attrifyString(preString: String, toAttrify: String,
                       color: UIColor) -> NSMutableAttributedString {
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .body)]
        let jumboAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 32, weight: .semibold),
            .foregroundColor: color]
        let attributedMessagePre = NSAttributedString(
            string: "\n\n\(preString)\n",
            attributes: regularAttributes)

        let attributedMessageJumbo = NSAttributedString(string: "\(toAttrify)\n",
                                                        attributes: jumboAttributes)

        let myAttributedText = NSMutableAttributedString()

        myAttributedText.append(attributedMessagePre)
        myAttributedText.append(attributedMessageJumbo)

        return myAttributedText
    }

}
