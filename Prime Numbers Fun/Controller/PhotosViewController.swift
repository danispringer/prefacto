//
//  PhotosViewController.swift
//  Prime Numbers Fun
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Images"
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
                    self.present(alert, animated: true)
                }
                return
            }
            guard let data = data else {
                
                print("No data")
                let alert = self.createAlert(alertReasonParam: alertReason.unknown.rawValue)
                DispatchQueue.main.async {
                    self.setUIEnabled(true)
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
                self.refreshButton.title = "Get new images"
            }
            
        } else {
            DispatchQueue.main.async {
                self.collectionView.alpha = 0.5
                self.activityIndicator.startAnimating()
                self.refreshButton.isEnabled = false
                self.refreshButton.title = "Loading..."
            }
        }
    }
}


