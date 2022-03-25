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
        case textfieldEmpty
        case notNumberOrTooBig
        case overflow
        case zero
        case one
        case two
        case negative
        case sameTwice
        case noPrimesInRange
        case unknown
    }


    func createAlert(alertReasonParam: AlertReason, num: Int64 = 0) -> UIAlertController {
        var alertTitle = ""
        var alertMessage = ""
        switch alertReasonParam {
            case .textfieldEmpty:
                alertTitle = NSLocalizedString("Textfield empty", comment: "")
                alertMessage = NSLocalizedString("Please enter a number.", comment: "")
            case .notNumberOrTooBig:
                alertTitle = NSLocalizedString("Invalid entry", comment: "")
                alertMessage = NSLocalizedString("""
                Only numbers allowed. No decimals.
                Max number: 9223372036854775807
                If your device is higher than 64-bit, please let me know: \(Const.UX.emailAddress)
                """, comment: "")
            case .zero:
                alertTitle = NSLocalizedString("0 not allowed here", comment: "")
                alertMessage = NSLocalizedString("""
                Please enter a different number.
                """, comment: "")
            case .one:
                alertTitle = NSLocalizedString("1 not allowed here", comment: "")
                alertMessage = NSLocalizedString("""
                Please enter a different number.
                """, comment: "")
            case .two:
                alertTitle = NSLocalizedString("2 not allowed here", comment: "")
                alertMessage = NSLocalizedString("""
            Please enter a different number.
            """, comment: "")
            case .negative:
                alertTitle = NSLocalizedString("Negative numbers not allowed here", comment: "")
                alertMessage = NSLocalizedString("""
                Please enter a different number.
                """, comment: "")
            case .sameTwice:
                alertTitle = NSLocalizedString("Same number entered twice", comment: "")
                alertMessage = NSLocalizedString("""
                Please enter two different numbers. To check if a single number is prime, use Check.
                """, comment: "")
            case .overflow:
                alertTitle = NSLocalizedString("Overflow", comment: "")
                alertMessage = """
                There are no primes above \(num) which are lower than 9223372036854775807 \
                (your device's limit)
                If your device is higher than 64-bit, please let me know: \(Const.UX.emailAddress)
                """
            default:
                alertTitle = NSLocalizedString("Unknown error", comment: "")
                alertMessage = NSLocalizedString("""
                An unknown error occurred. Please try again later, or contact us at \(Const.UX.emailAddress)
                """, comment: "")
        }
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
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

    func manyPrimesInRange(localFrom: Int64, localTo: Int64, localSource: [Int64]) -> String {
        return """
        From: \(localFrom)
        To: \(localTo)
        Count: \(localSource.count)
        Values: \(localSource)
        """
    }


    func isPrimeMessage(localNumber: Int64) -> String {
        return """
        Value: \(localNumber)
        Prime: Yes
        """
    }


    func isNotPrimeMessage(localNumber: Int64, localIsDivisibleBy: Int64) -> String {
        return """
        Value: \(localNumber)
        Prime: No
        Factor: \(localIsDivisibleBy)
        """
    }


    func manyPrimeFactors(localNumber: Int64, localSource: [Int64]) -> String {
        return """
        Value: \(localNumber)
        Count: \(localSource.count)
        Factors: \(localSource)
        """
    }


    func nextPrimeMessage(localOriginalNumber: Int64, localNextPrime: Int64) -> String {
        return """
        Value: \(localOriginalNumber)
        Next prime: \(localNextPrime)
        """
    }


    func previousPrimeMessage(localOriginalNumber: Int64, localPreviousPrime: Int64) -> String {
        return """
        Value: \(localOriginalNumber)
        Previous prime: \(localPreviousPrime)
        """
    }

}
