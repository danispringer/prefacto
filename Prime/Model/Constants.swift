//
//  Constants.swift
//  Prime
//
//  Created by Daniel Springer on 11/26/18.
//  Copyright © 2019 Daniel Springer. All rights reserved.
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


// MARK: Constants Struct

struct Constants {


    struct StoryboardID {
        static let main = "Main"
        static let checkResults = "CheckResultsViewController"
        static let settings = "SettingsViewController"
        static let listResults = "ListResultsViewController"
        static let factorizeResults = "FactorizeResultsViewController"
        static let randomResults = "RandomResultsViewController"
    }


    struct Messages {
        static let check = "Check"
        static let list = "List"
        static let factorize = "Factorize"
        static let done = "Done"
        static let cancel = "Cancel"
        static let version = "Version"
        static let appName = "Prime"
        static let placeholderText = "Enter number here"
        static let appVersion = "CFBundleShortVersionString"
        static let bundleAndRandom = "io.github.danispringer.Prime-Numbers-Fun.makeRandomShortcut"
        static let appReviewLink = "https://itunes.apple.com/app/id1402417667?action=write-review"
        static let showAppsButtonTitle = "More by Daniel Springer"
        static let devID = "1402417666"
        static let shareApp = "Tell a Friend"
        static let shareMessage = """
                   Hello,

                   • Meet Prime, the only prime numbers app you need
                   • Check whether any number is prime (example input: 13. Output: Is prime)
                   • List the primes in any range (example input: 1-10. Output: 1, 2, 3, 5, 7)
                   • Decompose any number to its prime factors (example input: 15. Output: 3, 5)
                   • Generate random primes, with choices of Extra-Small, Small, Medium, Large, \
                   and Extra-Large
                   • Generate medium primes using Siri
                   • Share or save any of your results


                   SETTINGS
                   • Choose between a light or dark app icon
                   • Choose to show or hide the thousands separator (1.234 VS 1234). \
                   Note that although the example here uses a period ("."), the app's \
                   separator will adapt based on your device's settings.


                   TIPS
                   • Long press on a number from a resulting list for an option to copy it
                   • Copy random primes using the copy button


                   • Ask us anything: ***REMOVED***
                   • Enjoying Prime? Please consider leaving a 5-star review. It would mean the \
                   world to us!

                   https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
                   """
        static let sendFeedback = "Contact Us"
        static let leaveReview = "Leave a Review"
        static let settings = "Settings"
        static let emailSample = "Hi. I have a question..."
        static let emailAddress = "***REMOVED***"
        static var noPrimesInRangeMessage: String {
            return """
            Hey, did you know that there are no prime numbers between \(localFrom) and \(localTo)? \
            I just found out, using this app: \
            https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var singlePrimeInRangeMessage: String {
            return """
            Hey, did you know that the only prime number between \(localFrom) and \(localTo) is \
            \(localSourceFirst)? I just found out, using this app: \
            https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var twoPrimesInRange: String {
            return """
            Hey, did you know that the only prime numbers between \(localFrom) and \(localTo) are \
            \(localSourceFirst) and \(localSourceLast)? I just found out, using this app: \
            https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var manyPrimesInrange: String {
            return """
            Hey, did you know that the prime numbers between \(localFrom) and \(localTo) are \
            \(localStringCleanedSourceDroppedLast), and \(localSourceLast)? That's no less than \
            \(localSource.count) numbers! I just found out, using this app: \
            https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var isPrimeMessage: String {
            return """
            Hey, did you know that \(localNumber) is a prime number? I just found out, using \
            this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var isNotPrimeMessage: String {
            return """
            Hey, did you know that \(localNumber) is not prime, because it is divisible by \
            \(localIsDivisibleBy)? I just found out, using this app: \
            https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var twoPrimeFactorsMessage: String {
            return """
            Hey, did you know that the prime factors of \(localNumber) are \(localSourceFirst) \
            and \(localSourceLast)? I just found out, using this app: \
            https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
        static var manyPrimeFactorsMessage: String {
            return """
            Hey, did you know that the prime factors of \(localNumber) are \
            \(localStringCleanedSourceDroppedLast), and \(localSourceLast)? That's no less than \
            \(localSource.count) numbers! I just found out, using this app: \
            https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }
    }


    struct Model {
        static let name = "Model"
        static let url = "url"
    }


    struct View {
        static let specialButtonColor = "SpecialButtonColor"
        static let specialSwitchColor = "SpecialSwitchColor"
    }


    struct UserDef {
        static let showSeparator = "showSeparator"
        static let selectedIcon = "selectedIcon"
        static let light = "light"
        static let dark = "dark"
    }


    struct Testing {
        static let testing = false
    }

}
