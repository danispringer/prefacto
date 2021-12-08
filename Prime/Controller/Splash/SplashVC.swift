//
//  SplashVC.swift
//  Prime
//
//  Created by Dani on 12/7/21.
//  Copyright © 2021 Dani Springer. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {


    // MARK: Outlets

    @IBOutlet weak var descriptionLabel: UILabel!


    // MARK: Properties

    let aString = """
What can Prime do for me?

1. Check whether a number is prime

2. Decompose a number to its prime factors

3. Share results from within the app

4. And more
"""

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = aString
    }


    // MARK: Actions

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true)
    }


}
