//
//  MyButton.swift
//  Prime
//
//  Created by Daniel Springer on 12/23/18.
//  Copyright © 2019 Dani Springer. All rights reserved.
//

import UIKit


class MyButton: UIButton {


    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }


    // MARK: Helpers

    private func setup() {
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        self.tintColor = Constants.View.goldColor
        self.setTitleColor(Constants.View.grayColor, for: .highlighted)
        self.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 30.0, bottom: 10.0, right: 30.0)
    }


}
