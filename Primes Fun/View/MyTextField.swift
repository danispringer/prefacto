//
//  MyTextField.swift
//  Primes Fun
//
//  Created by Daniel Springer on 12/23/18.
//  Copyright © 2019 Dani Springer. All rights reserved.
//

import UIKit


class MyTextField: UITextField {


    // MARK: Properties

    var bottomBorder = UIView()


    // MARK: Life Cycle

    override func awakeFromNib() {

        self.backgroundColor = .black
        self.textColor = .white
        self.tintColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.attributedPlaceholder = NSAttributedString(
            string: Constants.Messages.enterAnyNumber,
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.View.grayColor
            ])

        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = .white // Set Border-Color
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false

        addSubview(bottomBorder)

        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength

    }


}
