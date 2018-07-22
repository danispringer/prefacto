//
//  TutorialViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 22/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var myTextView: UITextView!
    
    
    // MARK: Properties
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }
    
    
    // Helpers
    
    @IBAction func backToTop(_ sender: Any) {
        myTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
    
    
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
