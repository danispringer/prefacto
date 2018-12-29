//
//  Alert.swift
//  Primes Fun
//
//  Created by Daniel Springer on 20/06/2018.
//  Copyright © 2018 Daniel Springer. All rights reserved.
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
        case permissionDenied
        case imageSaved
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
            alertMessage = "Textfield is empty. Please enter a number."
        case .notNumberOrTooBig:
            alertTitle = "Number too big or contains text"
            alertMessage = "No text allowed. Just numbers.\nMax number: 9223372036854775807\n(A.K.A.: 2^63 − 1)"
        case .zero:
            alertTitle = "Is 0 prime?"
            alertMessage = """
            Some people say it is prime, as its divisors are 1 and itself.
            Other disagree, as it is not divisible by itself.
            The definition of a prime number is a positive integer that has exactly two positive \
            divisors.
            Therefore, the simplest reason why 0 is not prime is that 0 is not a positive integer.
            Moreover, 0 also doesn't have exactly two positive divisors.
            A positive, integer divisor (D) of any number (N) is a positive, whole number which \
            divides N evenly, such that N/D has a remainder of 0.
            By this definition, we can prove that 0 does not have exactly two factors.
            Firstly, however, 0 is not a divisor of itself because 0/0=undefined.
            1 is a divisor of 0 since 0/1 = 0, which has a remainder of 0.
            Therefore, 1 is a divisor of 0.
            However, 1 is not 0’s only positive divisor.
            In fact, all positive integers are divisors of 0.
            For example, by the same reasoning that 1 is a divisor of 0, 2 is a divisor of 0 since \
            0/2=0, which has a remainder of 0.
            Similarly, all positive integers are divisors of 0, and, yes, this also implies that 0 \
            is a multiple of all positive integers.
            In summary, 0 is not positive and it has infinitely many positive divisors, so, no \
            matter how you look at it, 0 is not prime.
            """
        case .one:
            alertTitle = "Is 1 prime?"
            alertMessage = """
            Some say 1 is prime, as its positive divisors are 1 and itself.
            Others disagree, as it doesn't have exactly two positive divisors.
            """
        case .negative:
            alertTitle = "Can negative numbers be prime?"
            alertMessage = """
            Answer One: No.

            By the usual definition of prime for integers, negative integers can not be prime.

            By this definition, primes are integers greater than one with no positive divisors \
            besides one and itself. Negative numbers are excluded. In fact, they are given no \
            thought.

            Answer Two: Yes.

            Now suppose we want to bring in the negative numbers: then -A divides B whenever A \
            does, so we treat them as essentially the same divisor.
            This happens because -1 divides 1, which in turn divides everything.

            Numbers that divide by one are called units.
            Two numbers A and B for which A is a unit times B are called associates.
            So the divisors A and -A of B above are associates.

            In the same way, -3 and 3 are associates, and in a sense represent the same prime.

            So yes, negative integers can be prime (when viewed this way).
            In fact the integer -P is prime whenever P is, but since they are associates, \
            we don't really have any new primes.
            Let's illustrate this with another example.

            The Gaussian integers are the complex numbers A+BI where A and B are both integers.
            (Here I is the square root of -1).
            There are four units (integers that divide one) in this number system: 1, -1, I, \
            and -I.
            So each prime has four associates.

            It is therefore possible to create a system in which each prime has an infinite \
            amount of associates.

            Answer Three: It doesn't matter.

            In more general number fields the confusion above disappears.
            That is because most of these fields are not principal ideal domains and primes \
            are represented by ideals, not individual elements.
            Looked at this way, (-3) - the set of all multiples of -3 - is the same ideal as \
            (3) - the set of all multiples of 3.

            -3 and 3 then generate exactly the same prime ideal.
            """
        case .sameTwice:
            alertTitle = "Same number entered twice"
            alertMessage = """
            Cannot make a list from a single number. Please enter two different numbers.
            """
        case .messageSaved:
            alertTitle = "Message saved"
            alertMessage = "Your message has been saved to drafts."
        case .messageCanceled:
            alertTitle = "Action cancelled"
            alertMessage = "Your message has not been sent."
        case .messageFailed:
            alertTitle = "Action failed"
            alertMessage = """
            Your message has not been sent. Please try again later, or contact us by leaving a review.
            """
        case .messageSent:
            alertTitle = "Success!"
            alertMessage = "Your message has been sent. You should hear from us within 24 working hours."
        case .permissionDenied:
            alertTitle = "Allow Primes Fun access to your gallery"
            alertMessage = """
            Primes Fun needs access to your gallery in order to save your image. Please allow \
            access in Settings.
            """
        case .imageSaved:
            alertTitle = "Success!"
            alertMessage = "Your image has been saved to your library."
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
