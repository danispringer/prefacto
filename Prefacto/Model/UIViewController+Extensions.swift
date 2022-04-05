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
                alertTitle = "Textfield empty"
                alertMessage = "Please enter a number."
            case .notNumberOrTooBig:
                alertTitle = "Invalid entry"
                alertMessage = """
                Only numbers allowed (no decimals)
                Max number allowed: 9223372036854775807
                Need more help? Email: \(Const.UX.emailAddress)
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
            case .overflow:
                alertTitle = "Overflow"
                alertMessage = """
                There are no primes above \(num) which are lower than 9223372036854775807 \
                (your device's limit)
                Need more help? Email: \(Const.UX.emailAddress)
                """
            default:
                alertTitle = "Unknown error"
                alertMessage = """
                An unknown error occurred. Please try again.
                Need more help? Email: \(Const.UX.emailAddress)
                """
        }
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
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
