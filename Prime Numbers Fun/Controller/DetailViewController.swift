//
//  DetailViewController.swift
//  Prime Numbers Fun
//
//  Created by Dani Springer on 24/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var myToolbar: UIToolbar!

    // MARK: Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isOpaque = false
        self.myToolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        self.myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        detailImage.image = myImage
    }
    
    // MARK: Properties
    
    var myImage: UIImage! = nil
    
}
