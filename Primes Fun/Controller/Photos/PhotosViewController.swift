//
//  PhotosViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 20/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!
    
    
    // MARK: Properties
    
    var imagesArray = [UIImage]() // TODO: to be removed
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Images"
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        controller.myImage = imagesArray[(indexPath as NSIndexPath).row]
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true)
    }
    
    
    // MARK: Helper functions
    
    func getPhotos() {
        DispatchQueue.main.async {
            self.setUIEnabled(false)
        }
        
        FlickrClient.getPhotosAbstracted { data, errorReason in
            guard errorReason == nil else {
                
                let alert = self.createAlert(alertReasonParam: errorReason!)
                DispatchQueue.main.async {
                    self.setUIEnabled(true)
                    AppData.getSoundEnabledSettings(sound: Sound.negative)
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true)
                }
                return
            }
            guard let data = data else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown.rawValue)
                DispatchQueue.main.async {
                    self.setUIEnabled(true)
                    AppData.getSoundEnabledSettings(sound: Sound.negative)
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true)
                }
                return
            }
            self.imagesArray = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.setUIEnabled(true)
                AppData.getSoundEnabledSettings(sound: Sound.positive)
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
        DispatchQueue.main.async {
            self.refreshButton.isEnabled = enabled
            self.collectionView.alpha = enabled ? 1.0 : 0.5
            self.refreshButton.title = enabled ? "Get new images" : "Loading..."
            self.headerLabel.text = enabled ? "📸 Are all these prime? Find out!" :
            "🚂 Prime train is on the way. Get ready!"
            
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()

        }
    }
}
