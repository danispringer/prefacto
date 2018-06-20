//
//  PhotosViewController.swift
//  Is It Prime
//
//  Created by Dani Springer on 20/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: Properties
    
    var imagesArray = [UIImage]() // to be removed
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPhotos()
    }
    
    // MARK: CollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.cellImageView.image = imagesArray[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    // MARK: Helper functions
    
    func getPhotos() {
        DispatchQueue.main.async {
            self.setUIEnabled(false)
        }
        
        FlickrClient.getPhotosAbstracted { data, errorReason in
            guard errorReason == nil else {
                
                let alert = Alert.shared.createAlert(alertReasonParam: errorReason!)
                DispatchQueue.main.async {
                    self.setUIEnabled(false)
                    self.present(alert, animated: true)
                }
                return
            }
            guard let data = data else {
                
                print("No data")
                let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.unknown.rawValue)
                DispatchQueue.main.async {
                    self.setUIEnabled(false)
                    self.present(alert, animated: true)
                }
                return
            }
            self.imagesArray = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.setUIEnabled(true)
            }
        }
    }
    
    @IBAction func refreshButtonPressed() {
        getPhotos()
    }

}

// Mark: PhotosViewController (Configure UI)

private extension PhotosViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        
        if enabled {
            DispatchQueue.main.async {
                self.collectionView.alpha = 1.0
                self.activityIndicator.stopAnimating()
                self.refreshButton.isEnabled = true
            }
            
        } else {
            DispatchQueue.main.async {
                self.collectionView.alpha = 0.5
                self.activityIndicator.startAnimating()
                self.refreshButton.isEnabled = false
            }
        }
    }
}
