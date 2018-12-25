//
//  Constants.swift
//  Primes Fun
//
//  Created by Daniel Springer on 11/26/18.
//  Copyright © 2018 Daniel Springer. All rights reserved.
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
        static let enterAnyNumber = "Enter any number here"
        static let version = "Version"
        static let appName = "Primes Fun"
        static let appVersion = "CFBundleShortVersionString"
        static let bundleAndRandom = "io.github.danispringer.Prime-Numbers-Fun.makeRandomShortcut"
        static let appReviewLink = "https://itunes.apple.com/app/id1402417667?action=write-review"
        static let showAppsButtonTitle = "More by Daniel Springer"
        static let devID = "1402417666"
        static let shareApp = "Share App with friends"
        static let shareMessage = """
                   This app lets you check if a number is prime, \
                   list primes in a range, factorize, generate a random prime, and more. It's called \
                   Primes Fun. Check it out: \
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
        static let isOnePrimeMessage = """
                   Did you know?
                   Some say 1 is prime, as its positive divisors are 1 and itself.
                   Others disagree, as it doesn't have exactly two positive divisors.
                   Find out more about prime numbers with this app: \
                   https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
                   """
        static let isZeroPrimeMessage = """
            Did you know?
            Is 0 prime?
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
            Find out more about prime numbers with this app: \
            https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        static let isNegativePrimeMessage = """
            Did you know?

            Can negative numbers be prime?

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
            Find out more about prime numbers with this app: \
            https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
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


    struct UserDefaultsStrings {
        static let soundEnabled = "soundEnabled"
    }


    struct Font {
        static let AmericanTypewriter = "AmericanTypewriter"
    }


    struct Title {
        static let images = "Images"
    }


    struct Image {
        static let refresh = "refresh.png"
    }


    struct Sound {
        static let positive = 1023
        static let negative = 1257
        static let toggle = 1104
    }


    struct View {
        static let goldColor = UIColor(red: 0.99, green: 0.78, blue: 0.00, alpha: 1.0)
        static let grayColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0)
    }


}
