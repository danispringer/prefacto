//
//  UIButton+Extensions.swift
//  Prefacto
//
//  Created by Daniel Springer on 11/5/22.
//  Copyright © 2024 Daniel Springer. All rights reserved.
//

import UIKit

extension UIButton {

    func setTitleNew(_ title: String) {

        let oldFont: UIFont = self.configuration!.attributedTitle!.font ??
        UIFont.preferredFont(forTextStyle: .largeTitle)

        self.configurationUpdateHandler = { button in
            button.configuration!.attributedTitle = AttributedString(
                title, attributes: AttributeContainer([.font: oldFont]))
        }
    }

}
