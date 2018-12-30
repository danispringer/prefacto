//
//  UIImage+Extension.swift
//  Primes Fun
//
//  Created by Daniel Springer on 19/07/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit


extension UIImage {

    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }


}

// Usage:
// let img = UIImage.from(color: .black)
