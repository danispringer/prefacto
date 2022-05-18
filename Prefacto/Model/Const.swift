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


    enum TitleEnum: String, CaseIterable {
        // swiftlint:disable:next identifier_name
        case Check, List, Next, Previous, Factorize, Randomize
    }


    static let tintColorsArray: [UIColor] = [
        .systemGreen,
        .systemPurple,
        .systemTeal,
        .systemTeal,
        .systemBlue,
        .systemOrange
    ]


    static let myImageSource = ["checkmark",
                                "arrow.up.and.down",
                                "arrow.right",
                                "arrow.left",
                                "divide",
                                "wand.and.stars"]


    static var titleArrFromEnum: [String] {
        var mySampleArray: [String] = []
        for item in Const.TitleEnum.allCases {
            mySampleArray.append(item.rawValue)
        }
        return mySampleArray
    }


    // swiftlint:disable:next type_name
    struct UX {
        static let randomize = "Create Random Prime"
        static let done = "Done"
        static let cancel = "Cancel"
        static let version = "v."
        static let appName = "Prime Number App"
        static let appVersion = "CFBundleShortVersionString"
        static let bundleAndRandom = "io.github.danispringer.Prime-Numbers-Fun.makeRandomShortcut"
        static let appReviewLink = "https://apps.apple.com/app/id1402417667?action=write-review"
        static let showAppsButtonTitle = "More Apps"
        static let appsLink = "https://apps.apple.com/developer/id1402417666"
        static let thisAppLink = "https://apps.apple.com/app/id1402417667"
        static let devID = "1402417666"
        static let shareApp = "Tell a Friend"
        static let sendFeedback = "Contact Us"
        static let leaveReview = "Leave a Review"
        static let addToSiri = "Add to Siri"
        static let emailSample = "Hi. I have a question..."
        static let emailAddress = "00.segue_affix@icloud.com"

    }

}
// max num 64-bit phone can handle: 9223372036854775807
// largest prime under that limit: 9223372036854775783
