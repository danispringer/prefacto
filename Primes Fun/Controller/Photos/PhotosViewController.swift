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
import CoreData

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!
    
    
    // MARK: Properties
    
    var photo: Photo!
    
    var dataController: DataController!
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFetchedResultsController()
        
        self.title = "Images"
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: Core Data
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "url", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "url")
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: CollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects!.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        var imageUI = UIImage(named: "refresh.png")
        
        if let data = fetchedResultsController.fetchedObjects![indexPath.row].imageData {
            imageUI = UIImage(data: data)
            DispatchQueue.main.async {
                cell.cellImageView.image = imageUI
            }
            return cell
        }
        
        if let urlString = fetchedResultsController.fetchedObjects![indexPath.row].url {
            FlickrClient.downloadSingleImage(imgUrl: urlString) {
                (data, error) in
                
                guard error == nil else {
                    print("error")
                    return
                }
                
                imageUI = UIImage(data: data!)
                if let imageData = data {
                    imageUI =  UIImage(data: imageData)
                }
                
                self.fetchedResultsController.fetchedObjects![indexPath.row].imageData = data
                
                try? self.dataController.viewContext.save()
                
                DispatchQueue.main.async {
                    cell.cellImageView.image = imageUI
                }
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        controller.myImage = UIImage(data: fetchedResultsController.fetchedObjects![indexPath.row].imageData!)
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true)
    }
    
    
    // MARK: Helper functions
    
    func getImagesUrls() {
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
            guard let safeData = data else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown.rawValue)
                DispatchQueue.main.async {
                    self.setUIEnabled(true)
                    AppData.getSoundEnabledSettings(sound: Sound.negative)
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true)
                }
                return
            }
            
            for imageUrl in safeData {
                let dataToSave = Photo(context: self.dataController.viewContext)
                dataToSave.url = imageUrl
                try? self.dataController.viewContext.save()
            }
            self.setupFetchedResultsController()
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.setUIEnabled(true)
                AppData.getSoundEnabledSettings(sound: Sound.positive)
            }
        }
    }
    
    @IBAction func refreshButtonPressed() {
        for (index, _) in fetchedResultsController.fetchedObjects!.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            let toDelete = fetchedResultsController.object(at: indexPath)
            dataController.viewContext.delete(toDelete)

        }
        try? dataController.viewContext.save()
        print("count after emptying: \(String(describing: fetchedResultsController.fetchedObjects!.count))")
        
        getImagesUrls()
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
