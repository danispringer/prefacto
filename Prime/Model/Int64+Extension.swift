//
//  Int64+Extension.swift
//  Prime
//
//  Created by Daniel Springer on 9/5/19.
//  Copyright © 2019 Dani Springer. All rights reserved.
//

import UIKit

extension Int64 {

    struct IsPrime {
        var value: Int64
        var isPrime: Bool
        var divisor: Int64

        init(number: Int64) {
            self.value = number
            self.isPrime = false
            self.divisor = 0

            guard !(1...3).contains(number) else {
                self.isPrime = true
                self.divisor = 0
                return
            }
            for intruder: Int64 in [2, 3] where number % intruder == 0 {
                self.isPrime = false
                self.divisor = intruder
                return
            }
            var divisor: Int64 = 5
            var lever: Int64 = 2
            while divisor * divisor <= number {
                if number % divisor == 0 {
                    self.isPrime = false
                    self.divisor = divisor
                    return
                }
                divisor += lever
                lever = 6 - lever
            }
            self.isPrime = true
            self.divisor = 0
            return
        }
    }
}