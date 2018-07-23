//
//  DetailViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 24/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import StoreKit

class DetailViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var myToolbar: UIToolbar!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.isOpaque = false
        //self.myToolbar.barTintColor = UIColor.black
        
        detailImage.image = myImage
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
    }
    
    
    // MARK: Properties
    
    var myImage: UIImage! = nil
    let negativeSound: Int = 1257
    
    
    // MARK: Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [detailImage.image!], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown.rawValue)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true)
                    AppData.getSoundEnabledSettings(sound: self.negativeSound)
                }
                return
            }
        }
        self.present(activityController, animated: true)
    }
}
