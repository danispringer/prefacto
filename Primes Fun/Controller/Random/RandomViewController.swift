//
//  RandomViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 17/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit

class RandomViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var randomizeButton: UIButton!
    @IBOutlet weak var randomizeLabel: UILabel!
    
    
    // MARK: Properties
    
    
    
    
    // MARK: Life Cycle
    
    
    
    
    // MARK: Helpers
    
    @IBAction func randomizeButtonPressed(_ sender: Any) {
        enableUI(enabled: false)
        
        var randInt = Int(arc4random_uniform(1000000)+2)
        
        while !isPrime(number: randInt) {
            randInt += 1
        }
        
        enableUI(enabled: true)
        
        DispatchQueue.main.async {
            self.presentResult(number: randInt)
        }
    }
    
    
    func presentResult(number: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RandomResultsViewController") as! RandomResultsViewController
        controller.number = number
        
        DispatchQueue.main.async {
            self.enableUI(enabled: true)
            self.present(controller, animated: true)
        }
        
    }
    
    
    func isPrime(number: Int) -> Bool {
        
        guard number != 1, number != 2, number != 3 else {
            return true
        }
        
        var isPrimeBool = true
        let range = 2...(number - 1)
        
        for n in range {
            if number % n == 0 {
                // not prime
                isPrimeBool = false
                break
            }
        }
        return isPrimeBool
    }
    
    
    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            if enabled {
                self.activityIndicator.stopAnimating()
                self.randomizeButton.isEnabled = enabled
                self.randomizeLabel.text = "Random Prime"
                self.view.alpha = 1
            } else {
                self.activityIndicator.startAnimating()
                //self.view.endEditing(true)
                self.randomizeButton.isEnabled = enabled
                self.randomizeLabel.text = "Randomizing..."
                self.view.alpha = 0.5
            }
        }
    }
    
}
