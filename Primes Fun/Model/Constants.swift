//
//  Constants.swift
//  Primes Fun
//
//  Created by Dani Springer on 11/26/18.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation

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

struct Constants {
    struct StoryboardID {
        static let main = "Main"
        static let checkerResults = "CheckerResultsViewController"
        static let tutorial = "TutorialViewController"
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
        static let cancel = "Cancel"
        static let version = "Version"
        static let appName = "Primes Fun"
        static let appVersion = "CFBundleShortVersionString"
        static let appReviewLink = "https://itunes.apple.com/app/id1402417667?action=write-review"
        static let shareApp = "Share App with friends"
        static let shareMessage = """
                   Check this app out: Primes Fun lets you check if a number is prime, \
                   list primes in a range, factorize, generate a random prime, and more! \
                   https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
                   """
        static let sendFeedback = "Send feedback or question"
        static let leaveReview = "Leave a review"
        static let tutorial = "Tutorial"
        static let settings = "Settings"
        static let openSettings = "Open Settings"
        static let openGallery = "Open Gallery"
        static let galleryLink = "photos-redirect://"
        static let emailSample = "Hi. I have a question..."
        static let emailAddress = "musicbyds@icloud.com"
        static let soundEnabled = "soundEnabled"
        static let fontAmericanTypewriter = "AmericanTypewriter"
        static let noPrimesInRangeMessage = """
        Hey, did you know that there are no prime numbers between \(localFrom) and \(localTo)? \
        I just found out, using this app: \
        https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
        """
        static let singlePrimeInRangeMessage = """
        Hey, did you know that the only prime number between \(localFrom) and \(localTo) is \
        \(localSourceFirst)? I just found out, using this app: \
        https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
        """
        static let twoPrimesInRange = """
        Hey, did you know that the only prime numbers between \(localFrom) and \(localTo) are \
        \(localSourceFirst) and \(localSourceLast)? I just found out, using this app: \
        https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
        """
        static let manyPrimesInrange = """
        Hey, did you know that the prime numbers between \(localFrom) and \(localTo) are \
        \(localStringCleanedSourceDroppedLast), and \(localSourceLast)? That's no less than \
        \(localSource.count) numbers! I just found out, using this app: \
        https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
        """
        static let isPrimeMessage = """
        Hey, did you know that \(localNumber) is a prime number? I just found out, using \
        this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
        """
        static let twoPrimeFactorsMessage = """
        Hey, did you know that the prime factors of \(localNumber) are \(localSourceFirst) \
        and \(localSourceLast)? I just found out, using this app: \
        https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
        """
        static let manyPrimeFactorsMessage = """
        Hey, did you know that the prime factors of \(localNumber) are \
        \(localStringCleanedSourceDroppedLast), and \(localSourceLast)? That's no less than \
        \(localSource.count) numbers! I just found out, using this app: \
        https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
        """
    }
}
