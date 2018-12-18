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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myTextView.flashScrollIndicators()
        myTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))

    }

    // Helpers

    @IBAction func backToTop(_ sender: Any) {
        myTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator = scrollView.subviews.last as? UIImageView
        verticalIndicator?.backgroundColor = UIColor(red: 0.93, green: 0.90, blue: 0.94, alpha: 1.0)
    }

}
