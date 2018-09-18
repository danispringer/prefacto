//
//  RandomViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 17/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

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
        
        
        var randInt = Int64(arc4random_uniform(4294967292)+2)
        
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
    
    
    func presentResult(number: Int64) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RandomResultsViewController") as! RandomResultsViewController
        controller.number = number
        
        DispatchQueue.main.async {
            self.enableUI(enabled: true)
            self.present(controller, animated: false)
        }
        
    }
    
    
    func isPrime(number: Int64) -> Bool {
        
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
        
        guard !(number % 3 == 0) else {
            return false
        }
        
        var i: Int64 = 5
        var w: Int64 = 2
        
        while i * i <= number {
            if number % i == 0 {
                return false
            }
            i += w
            w = 6 - w
        }
        return true
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
