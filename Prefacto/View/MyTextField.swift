//
//  MyTextField.swift
// Prefacto
//
//  Created by Daniel Springer on 12/23/18.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit


class MyTextField: UITextField {
    
    
    // MARK: Properties
    
    var bottomBorder = UIView()
    
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        
        let firstColor: UIColor = UIColor.label
        
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = firstColor
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bottomBorder)
        
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border thickness
        
        self.textColor = firstColor
        
    }
    
}
