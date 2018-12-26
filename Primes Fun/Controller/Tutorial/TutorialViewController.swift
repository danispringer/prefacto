//
//  TutorialViewController.swift
//  Primes Fun
//
//  Created by Daniel Springer on 22/07/2018.
//  Copyright © 2018 Daniel Springer. All rights reserved.
//

import UIKit
import Foundation


class TutorialViewController: UIViewController, UITextViewDelegate {


    // MARK: Outlets

    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var myTextView: UITextView!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        myTextView.delegate = self
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        myTextView.isScrollEnabled = true
        myTextView.indicatorStyle = .white

        let longString = """
Intro

• Primes Fun lets you work with prime numbers in 5 different  ways: \
Checker, List, Factorize, Randomize, and Images.


Some Tips

• In addition to using the Randomize page of the app, you can use Siri to get random primes. \
To do so: open Settings > Siri & Search > All Shortcuts > Get random prime, then record the phrase \
you want to tell Siri whenever you want Siri to get you a random prime.
Note: In order to set up Siri Shortcuts, your device needs to be running iOS 12 or later, and in \
order to see the 'Get random prime' shortcut available, you must first generated at least 1 random \
prime in the app itself.

• If a page is calculating or images are downloading, switching to a different page will not \
interrupt that.

• You can tap on the share button to share a result or image with friends, or save it to your \
phone's files or gallery.

• Tapping on 'Get new images' deletes the downloaded images and replaces them with new ones. \
If you want to keep any of them, save them to your phone's gallery, using the share button, before \
getting new images.

• You can turn the app's sounds on or off in the app's settings.


Checker

• Check whether any number is prime, and if it is not, what it is divisible by. \
• Type or paste a number, and tap on 'Check'.
• Find a prime number to hear a satisfying 'Choo'!


List

• Create a list with all the prime numbers in a given range: for example, type 1 in the first \
text box, 10 in the second, then tap on List, and you will get 1, 2, 3, 5, and 7.


Factor

• Generate a list of the prime factors for any number: for example, type 12, and you will get \
2, 3, and 3.


Random

• Generate a random prime of a size of your choice.


Images

• Download random (clean) images from the internet - all with one thing in common: prime numbers.
\n\n\n\n\n\n\n
"""

        let myTitleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: Constants.Font.math, size: 40)!
        ]

        let myTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: Constants.Font.math, size: 25)!,
            NSAttributedString.Key.foregroundColor: UIColor.white]

        let longAttributedString = NSMutableAttributedString(string: longString, attributes: myTextAttributes)

        let myRanges: [NSRange] = [
            NSRange(location: 0, length: 5),
            NSRange(location: 126, length: 9),
            NSRange(location: 1134, length: 7),
            NSRange(location: 1322, length: 4),
            NSRange(location: 1506, length: 6),
            NSRange(location: 1623, length: 6),
            NSRange(location: 1685, length: 6)
        ]

        for range in myRanges {
            longAttributedString.addAttributes(myTitleAttributes, range: range)
        }

        myTextView.attributedText = longAttributedString


    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // TODO: fix not scrolling to bottom
        scrollTextViewToBottom(textView: myTextView)

    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myTextView.flashScrollIndicators()
        myTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))

    }


    // Helpers

    @IBAction func backToTop(_ sender: Any) {
        myTextView.flashScrollIndicators()
        myTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }


    func scrollTextViewToBottom(textView: UITextView) {
        if textView.text.count > 0 {
            print("ok")
            let bottomOffset = CGPoint(x: 0, y: textView.contentSize.height - textView.bounds.size.height)
            textView.setContentOffset(bottomOffset, animated: true)
        }
    }


    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator = scrollView.subviews.last as? UIImageView
        verticalIndicator?.backgroundColor = .white
    }


}
