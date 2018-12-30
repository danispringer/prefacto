//
//  TutorialViewController.swift
//  Primes Fun
//
//  Created by Daniel Springer on 22/07/2018.
//  Copyright © 2018 Daniel Springer. All rights reserved.
//

import UIKit


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

        let myTitleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: Constants.Font.math, size: 40)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]

        let myTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: Constants.Font.math, size: 25)!,
            NSAttributedString.Key.foregroundColor: UIColor.white]

        let title1 = NSAttributedString(string: Constants.Tutorial.title1, attributes: myTitleAttributes)
        let body1 = NSAttributedString(string: Constants.Tutorial.body1, attributes: myTextAttributes)
        let title2 = NSAttributedString(string: Constants.Tutorial.title2, attributes: myTitleAttributes)
        let body2 = NSAttributedString(string: Constants.Tutorial.body2, attributes: myTextAttributes)
        let title3 = NSAttributedString(string: Constants.Tutorial.title3, attributes: myTitleAttributes)
        let body3 = NSAttributedString(string: Constants.Tutorial.body3, attributes: myTextAttributes)
        let title4 = NSAttributedString(string: Constants.Tutorial.title4, attributes: myTitleAttributes)
        let body4 = NSAttributedString(string: Constants.Tutorial.body4, attributes: myTextAttributes)
        let title5 = NSAttributedString(string: Constants.Tutorial.title5, attributes: myTitleAttributes)
        let body5 = NSAttributedString(string: Constants.Tutorial.body5, attributes: myTextAttributes)
        let title6 = NSAttributedString(string: Constants.Tutorial.title6, attributes: myTitleAttributes)
        let body6 = NSAttributedString(string: Constants.Tutorial.body6, attributes: myTextAttributes)

        let longAttributedString = NSMutableAttributedString()

        for attributedString in [title1, body1, title2, body2, title3, body3, title4, body4,
                                 title5, body5, title6, body6] {
            longAttributedString.append(attributedString)
        }

        myTextView.attributedText = longAttributedString

    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myTextView.flashScrollIndicators()

        scrollTextViewToBottom(textView: myTextView)
        myTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))

    }


    // Helpers

    @IBAction func backToTop(_ sender: Any) {
        myTextView.flashScrollIndicators()
        myTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }


    func scrollTextViewToBottom(textView: UITextView) {
        if textView.attributedText.length > 0 {
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
