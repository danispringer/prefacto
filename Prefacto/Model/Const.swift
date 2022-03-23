//
//  Constants.swift
//  Prefacto
//
//  Created by Daniel Springer on 11/26/18.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit


// MARK: Properties

// swiftlint:disable:next identifier_name
let UD = UserDefaults.standard
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


    // swiftlint:disable:next type_name
    struct UX {
        static let randomize = NSLocalizedString("Create Random Prime", comment: "")
        static let done = NSLocalizedString("Done", comment: "")
        static let cancel = NSLocalizedString("Cancel", comment: "")
        static let version = NSLocalizedString("v.", comment: "")
        static let appName = "Prefacto"
        static let placeholderText = NSLocalizedString("Enter number here", comment: "")
        static let appVersion = "CFBundleShortVersionString"
        static let bundleAndRandom = "io.github.danispringer.Prime-Numbers-Fun.makeRandomShortcut"
        static let appReviewLink = "https://apps.apple.com/app/id1402417667?action=write-review"
        static let showAppsButtonTitle = NSLocalizedString("More Apps", comment: "")
        static let appsLink = "https://apps.apple.com/developer/id1402417666"
        static let thisAppLink = "https://apps.apple.com/app/id1402417667"
        static let devID = "1402417666"
        static let shareApp = NSLocalizedString("Tell a Friend", comment: "")
        static let sendFeedback = NSLocalizedString("Contact Us", comment: "")
        static let leaveReview = NSLocalizedString("Leave a Review", comment: "")
        static let addToSiri = NSLocalizedString("Add to Siri", comment: "")
        static let emailSample = NSLocalizedString("Hi. I have a question...", comment: "")
        static let emailAddress = "dani.springer@icloud.com"

    }

}
// max num 64-bit phone can handle: 9223372036854775807
// largest prime under that limit: 9223372036854775783
