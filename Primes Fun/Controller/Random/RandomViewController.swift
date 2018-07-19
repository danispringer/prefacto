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
    @IBOutlet weak var myToolbar: UIToolbar!
    
    
    // MARK: Properties
    
    
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }
    
    
    // MARK: Helpers
    
    @IBAction func randomizeButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.enableUI(enabled: false)
        }
        
        
        var randInt = Int(arc4random_uniform(100000007)+2)
        
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        downloadQueue.async {
            while !self.isPrime(number: randInt) {
                randInt += 1
            }
            
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.presentResult(number: randInt)
            }
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
        
        guard number != 1 else {
            return true
        }
        
        guard number != 2 else {
            return true
        }
        
        guard number != 3 else {
            return true
        }
        
        guard !(number % 2 == 0) else {
            return false
        }
        
        let highLimit = (number - 1) / 2
        
        let range = 2...(highLimit)
        
        var isPrimeBool = true
        
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
            self.randomizeButton.isHidden = !enabled
            self.randomizeButton.isEnabled = enabled
            self.randomizeLabel.text = enabled ? "Random Prime" : "Randomizing..."
            self.view.alpha = enabled ? 1 : 0.5
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()
            self.view.endEditing(!enabled)
        }
    }
    
}
