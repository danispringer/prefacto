//
//  Constants.swift
//  Prime
//
//  Created by Daniel Springer on 11/26/18.
//  Copyright © 2021 Daniel Springer. All rights reserved.
//

import UIKit

// MARK: Properties

var localFrom: Int64 = 0
var localTo: Int64 = 0
var localSourceFirst: Int64 = 0
var localSourceLast: Int64 = 0
var localSource: [Int64] = []
var localCleanedSourceDroppedLast: [Int64] = []
var localSourceDroppedLastArray: [Int64] = []
var localStringSourceDroppedLast: String = ""
var localStringCleanedSourceDroppedLast: String = ""
var localStart: String.Index = String.Index(utf16Offset: 0, in: "") //String.Index(encodedOffset: 0)
var localEnd: String.Index = String.Index(utf16Offset: 0, in: "") //String.Index(encodedOffset: 0)
var localRange: Range<String.Index> = " ".index(
    " ".startIndex, offsetBy: 0)..<" ".index(" ".startIndex, offsetBy: 1)
var localNumber: Int64 = 0
var localIsDivisibleBy: Int64 = 0
var localOriginalNumber: Int64 = 0
var localNextPrime: Int64 = 0
var localPreviousPrime: Int64 = 0

let UDStan = UserDefaults.standard
let notif = NotificationCenter.default

// MARK: Constants Struct

struct Const {

    struct StoryboardID {
        static let main = "Main"
        static let check = "CheckViewController"
        static let checkResults = "CheckResultsViewController"
        static let factorize = "FactorizeViewController"
        static let factorizeResults = "FactorizeResultsViewController"
        static let list = "ListViewController"
        static let listResults = "ListResultsViewController"
        static let random = "RandomViewController"
        static let randomResults = "RandomResultsViewController"
        static let next = "NextViewController"
        static let nextResults = "NextResultsViewController"
        static let previous = "PreviousViewController"
        static let previousResults = "PreviousResultsViewController"
    }


    struct Title {
        static let check = NSLocalizedString("Check", comment: "")
        static let factorize = NSLocalizedString("Factorize", comment: "")
        static let list = NSLocalizedString("List", comment: "")
        static let random = NSLocalizedString("Randomize", comment: "")
        static let next = NSLocalizedString("Next", comment: "")
        static let previous = NSLocalizedString("Previous", comment: "")
    }


    struct Messages {
        static let randomize = NSLocalizedString("Create Random Prime", comment: "")
        static let done = NSLocalizedString("Done", comment: "")
        static let cancel = NSLocalizedString("Cancel", comment: "")
        static let version = NSLocalizedString("v.", comment: "")
        static let appName = "Prime"
        static let placeholderText = NSLocalizedString("Enter number here", comment: "")
        static let appVersion = "CFBundleShortVersionString"
        static let bundleAndRandom = "io.github.danispringer.Prime-Numbers-Fun.makeRandomShortcut"
        static let appReviewLink = "https://itunes.apple.com/app/id1402417667?action=write-review"
        static let showAppsButtonTitle = NSLocalizedString("More Apps", comment: "")
        static let appsLink = "https://itunes.apple.com/developer/id1402417666"
        static let devID = "1402417666"
        static let shareApp = NSLocalizedString("Tell a Friend", comment: "")
        static let shareMessage = NSLocalizedString("""
                   • Check whether a number is prime
                   • List the primes in a range
                   • Decompose a number to its prime factors
                   • Share or save your results
                   • And more

                   • Ask us anything: dani.springer@icloud.com
                   • Enjoying Prime? Please consider leaving a 5-star review. It would mean the world to us!

                   https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
                   """, comment: "")
        static let sendFeedback = NSLocalizedString("Contact Us", comment: "")
        static let leaveReview = NSLocalizedString("Leave a Review", comment: "")
        static let addToSiri = NSLocalizedString("Add to Siri", comment: "")
        static let emailSample = NSLocalizedString("Hi. I have a question...", comment: "")
        static let emailAddress = "dani.springer@icloud.com"
        static var noPrimesInRangeMessage: String {
            return """
            Hey, did you know that there are no prime numbers between \(localFrom) and \(localTo)? \

            I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var singlePrimeInRangeMessage: String {
            return """
            Hey, did you know that the only prime number between \(localFrom) and \(localTo) is \
            \(localSourceFirst)?

            I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var twoPrimesInRange: String {
            return """
            Hey, did you know that the only prime numbers between \(localFrom) and \(localTo) are \
            \(localSourceFirst) and \(localSourceLast)?

            I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var manyPrimesInrange: String {
            return """
            Hey, did you know that the prime numbers between \(localFrom) and \(localTo) are \
            \(localStringCleanedSourceDroppedLast), and \(localSourceLast)? That's no less than \
            \(localSource.count) numbers!

            I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var isPrimeMessage: String {
            return """
            Hey, did you know that \(localNumber) is a prime number?

            I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var isNotPrimeMessage: String {
            return """
            Hey, did you know that \(localNumber) is not prime, because it is divisible by \
            \(localIsDivisibleBy)?
            I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var twoPrimeFactorsMessage: String {
            return """
            Hey, did you know that the prime factors of \(localNumber) are \(localSourceFirst) \
            and \(localSourceLast)?

            I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var manyPrimeFactorsMessage: String {
            return """
            Hey, did you know that the prime factors of \(localNumber) are \
            \(localStringCleanedSourceDroppedLast), and \(localSourceLast)? That's no less than \
            \(localSource.count) numbers!

            I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var nextPrimeMessage: String {
            return """
            Hey, did you know that the next prime after \(localOriginalNumber) is \(localNextPrime)? \

            I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var previousPrimeMessage: String {
            return """
            Hey, did you know that the previous prime before \(localOriginalNumber) is \(localPreviousPrime)? \

            I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
    }


    struct UserDef {
        static let selectedTextField = "selectedTextField"
        static let numFromList = "numFromList"
    }

}
// 9223372036854775807
