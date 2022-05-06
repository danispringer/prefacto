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
        case higherPlease
        case sameTwice
        case noPrimesInRange
        case unknown
    }
    
    
    func createAlert(alertReasonParam: AlertReason, num: Int64 = 0, higherThann: Int64 = -999) -> UIAlertController {
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
                Need more help? Email: \(Const.UX.emailAddress)
                """
            case .higherPlease:
                alertTitle = "Please enter a higher number"
                alertMessage = """
                Please enter a number higher than \(higherThann)
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
