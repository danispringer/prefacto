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
    }


    func createAlert(alertReasonParam: AlertReason, num: UInt64 = 0) -> UIAlertController {
        var alertTitle = ""
        var alertMessage = ""
        switch alertReasonParam {
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
                Highest number allowed: 9223372036854775807
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
                Please enter two different numbers. To check if a single number is prime, use Check
                """
            case .overflow:
                alertTitle = "Please enter a lower number"
                alertMessage = """
                There are no primes above \(num) which are lower than 9223372036854775807 \
                (your device's limit)
                """
            default:
                alertTitle = "Unknown error"
                alertMessage = """
                An unknown error occurred. Please try again.
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


    // MARK: Many

    func manyPrimesInRangeShare(localFrom: UInt64, localTo: UInt64, localSource: [UInt64]) -> String {

        guard localSource.count > 0 else {
            return """
            There are no primes between
            \(localFrom)
            and
            \(localTo)
            """
        }

        return """
        From: \(localFrom)
        To: \(localTo)
        Count: \(localSource.count)
        Values: \(localSource)
        """
    }


    // MARK: Is Prime

    func isPrimeMessage(localNumber: UInt64, color: UIColor) -> NSMutableAttributedString {
        let aString = attrifyString(preString: "Value:", toAttrify: "\(localNumber)", color: color)
        aString.append(attrifyString(preString: "Prime:", toAttrify: "Yes", color: color))
        return aString
    }


    func isPrimeMessageShare(localNumber: UInt64) -> String {
        let aString = "Value: \(localNumber)\nPrime: Yes"
        return aString
    }


    // MARK: Is Not Prime

    func isNotPrimeMessage(localNumber: UInt64, localIsDivisibleBy: UInt64,
                           color: UIColor) -> NSMutableAttributedString {
        let aString = attrifyString(preString: "Value:", toAttrify: "\(localNumber)", color: color)
        aString.append(attrifyString(preString: "Prime:", toAttrify: "No", color: color))
        aString.append(attrifyString(preString: "Factor:", toAttrify: "\(localIsDivisibleBy)", color: color))
        return aString
    }


    func isNotPrimeMessageShare(localNumber: UInt64, localIsDivisibleBy: UInt64) -> String {
        return "Value: \(localNumber)\nPrime: No\nFactor: \(localIsDivisibleBy)"
    }


    // MARK: Many Factors

    func manyPrimeFactors(localNumber: UInt64, localSource: [UInt64], color: UIColor) -> NSMutableAttributedString {
        let aString = attrifyString(preString: "Value:", toAttrify: "\(localNumber)", color: color)
        aString.append(attrifyString(preString: "Count:", toAttrify: "\(localSource.count)", color: color))
        aString.append(attrifyString(preString: "Factors:", toAttrify: "\(localSource)", color: color))
        return aString
    }


    func manyPrimeFactorsShare(localNumber: UInt64, localSource: [UInt64]) -> String {
        return """
        Value: \(localNumber)
        Count: \(localSource.count)
        Factors: \(localSource)
        """
    }


    // MARK: Next

    func nextPrimeMessage(localOriginalNumber: UInt64, localNextPrime: UInt64,
                          color: UIColor) -> NSMutableAttributedString {
        let aString = attrifyString(preString: "Value:", toAttrify: "\(localOriginalNumber)", color: color)
        aString.append(attrifyString(preString: "Next prime:", toAttrify: "\(localNextPrime)", color: color))
        return aString
    }


    func nextPrimeMessageShare(localOriginalNumber: UInt64, localNextPrime: UInt64) -> String {
        return """
        Value: \(localOriginalNumber)
        Next prime: \(localNextPrime)
        """
    }


    // MARK: Previous

    func previousPrimeMessage(localOriginalNumber: UInt64, localPreviousPrime: UInt64,
                              color: UIColor) -> NSMutableAttributedString {
        let aString = attrifyString(preString: "Value:", toAttrify: "\(localOriginalNumber)", color: color)
        aString.append(attrifyString(preString: "Previous prime:", toAttrify: "\(localPreviousPrime)", color: color))
        return aString
    }


    func previousPrimeMessageShare(localOriginalNumber: UInt64, localPreviousPrime: UInt64) -> String {
        return """
        Value: \(localOriginalNumber)
        Previous prime: \(localPreviousPrime)
        """
    }


    func attrifyString(preString: String, toAttrify: String, color: UIColor) -> NSMutableAttributedString {
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .body)]
        let jumboAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 100, weight: .semibold),
            .foregroundColor: color]
        let attributedMessagePre = NSAttributedString(
            string: "\n\n\(preString)\n",
            attributes: regularAttributes)

        let attributedMessageJumbo = NSAttributedString(string: "\(toAttrify)\n", attributes: jumboAttributes)

        let myAttributedText = NSMutableAttributedString()

        myAttributedText.append(attributedMessagePre)
        myAttributedText.append(attributedMessageJumbo)

        return myAttributedText
    }

}
