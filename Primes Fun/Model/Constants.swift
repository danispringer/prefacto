//
//  Constants.swift
//  Primes Fun
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
var localStart: String.Index = String.Index(encodedOffset: 0)
var localEnd: String.Index = String.Index(encodedOffset: 0)
var localRange: Range<String.Index> = " ".index(
    " ".startIndex, offsetBy: 0)..<" ".index(" ".startIndex, offsetBy: 1)
var localNumber: Int64 = 0
var localIsDivisibleBy: Int64 = 0


// MARK: Constants Struct

struct Constants {


    struct StoryboardID {
        static let main = "Main"
        static let checkerResults = "CheckerResultsViewController"
        static let settings = "SettingsViewController"
        static let listResults = "ListResultsViewController"
        static let factorizeResults = "FactorizeResultsViewController"
        static let randomResults = "RandomResultsViewController"
        static let detail = "DetailViewController"
    }


    struct Messages {
        static let check = "Check"
        static let list = "List"
        static let factor = "Factor"
        static let done = "Done"
        static let enterAnyNumber = "Enter any number here"
        static let version = "Version"
        static let appName = "Primes Fun"
        static let appVersion = "CFBundleShortVersionString"
        static let bundleAndRandom = "io.github.danispringer.Prime-Numbers-Fun.makeRandomShortcut"
        static let appReviewLink = "https://itunes.apple.com/app/id1402417667?action=write-review"
        static let showAppsButtonTitle = "More by Daniel Springer"
        static let devID = "1402417666"
        static let shareApp = "Tell a Friend"
        static let shareMessage = """
                   This app lets you check if a number is prime, \
                   list primes in a range, factorize, generate a random prime, and more. It's called \
                   Primes Fun. Check it out: \
                   https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
                   """
        static let sendFeedback = "Contact Us"
        static let leaveReview = "Leave a review"
        static let settings = "Settings"
        static let emailSample = "Hi. I have a question..."
        static let emailAddress = "musicbyds@icloud.com"
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


    struct UserDef {
        static let soundEnabled = "soundEnabled"
        static let darkModeEnabled = "darkModeEnabled"
        static let showSeparator = "showSeparator"
    }


    struct Sound {
        static let positive = 1023
        static let negative = 1257
        static let toggle = 1104
    }


    struct View {
        static let goldColor = UIColor(red: 0.99, green: 0.78, blue: 0.00, alpha: 1.0)
        static let grayColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0)
        static let blueColor = UIColor(red: 0.00/255, green: 122.00/255, blue: 255.00/255, alpha: 1.0)
        static let greenColor = UIColor(red: 76.00/255, green: 217.00/255, blue: 100.00/255, alpha: 1.0)
    }


}
