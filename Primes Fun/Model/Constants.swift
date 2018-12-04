//
//  Constants.swift
//  Primes Fun
//
//  Created by Dani Springer on 11/26/18.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation

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
                   https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!
                   """
        static let sendFeedback = "Send feedback or question"
        static let leaveReview = "Leave a review"
        static let tutorial = "Tutorial"
        static let settings = "Settings"
        static let openSettings = "Open Settings"
        static let openGallery = "Open Gallery"
        static let galleryLink = "photos-redirect://"
        static let emailSample = "Hi. I have a question..."
        static let emailAddress = "***REMOVED***"
        static let soundEnabled = "soundEnabled"
        static let fontAmericanTypewriter = "AmericanTypewriter"
    }
}
