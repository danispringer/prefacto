//
//  Mail+Extensions.swift
//  Primes Fun
//
//  Created by Daniel Springer on 12/23/18.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import MessageUI


extension MFMailComposeViewController {


    // MARK: Life Cycle

    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = Constants.View.goldColor
    }

}
