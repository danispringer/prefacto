//
//  UInt64+Extension.swift
//  Prefacto
//
//  Created by Daniel Springer on 9/5/19.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit

extension UInt64 {

    struct IsPrime {
        var value: UInt64
        var isPrime: Bool
        var divisor: UInt64

        init(number: UInt64) {
            self.value = number
            self.isPrime = false
            self.divisor = 0

            guard !(1...3).contains(number) else {
                self.isPrime = true
                self.divisor = 0
                return
            }
            for intruder: UInt64 in [2, 3]
            where number % intruder == 0 {
                self.isPrime = false
                self.divisor = intruder
                return
            }
            var divisor: UInt64 = 5
            var lever: UInt64 = 2

            while divisor * divisor <= number {
                if number % divisor == 0 {
                    self.isPrime = false
                    self.divisor = divisor
                    return
                }
                divisor += lever
                let thing = divisor.multipliedReportingOverflow(by: divisor)
                if thing.overflow {
                    break // to avoid crashes and such. Seems to work. Hard to verify if returned primes
                    // are indeed always prime.
                }
                lever = 6 - lever
            }
            self.isPrime = true
            self.divisor = 0
            return
        }
    }
}
