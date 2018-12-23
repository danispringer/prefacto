//
//  MyButton.swift
//  Primes Fun
//
//  Created by Daniel Springer on 12/23/18.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit

class MyButton: UIButton {

    let dark = UIColor(red: 0.00, green: 0.16, blue: 0.21, alpha: 1.0)
    let light = UIColor(red: 0.93, green: 0.90, blue: 0.94, alpha: 1.0)
    let silver =  UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        self.tintColor = dark
        self.backgroundColor = light
        self.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 30.0, bottom: 10.0, right: 30.0)
    }
}
