//
//  PhotosViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 20/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import MessageUI
import StoreKit


class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    
    // MARK: Properties
    
    var photo: Photo!
    
    var dataController: DataController!
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    let cellID = "Cell"
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFetchedResultsController()
        
        self.title = "Images"
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            let indicator = scrollView.subviews.last as? UIImageView
            indicator?.image = nil
            indicator?.backgroundColor = UIColor(red:0.93, green:0.90, blue:0.94, alpha:1.0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects!.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CollectionViewCell
        
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
                    return
                }
                
                imageUI = UIImage(data: data!)
                if let imageData = data {
                    imageUI =  UIImage(data: imageData)
                }
                
                
                DispatchQueue.main.async {
                    self.fetchedResultsController.fetchedObjects![indexPath.row].imageData = data
                    try? self.dataController.viewContext.save()
                    
                    cell.cellImageView.image = imageUI
                }
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.storyboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Constants.storyboardID.detail) as! DetailViewController
        controller.myImage = UIImage(data: fetchedResultsController.fetchedObjects![indexPath.row].imageData!)
        controller.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.async {
            self.present(controller, animated: true)
        }
        
    }
    
    
    // MARK: Helper functions
    
    func getImagesUrls() {
        
        DispatchQueue.main.async {
            self.setUIEnabled(false)
        }
        
        FlickrClient.getPhotosAbstracted { data, errorReason in
            
            guard errorReason == .noError else {
                
                let alert = self.createAlert(alertReasonParam: errorReason)
                DispatchQueue.main.async {
                    self.setUIEnabled(true)
                    AppData.getSoundEnabledSettings(sound: Sound.negative)
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true)
                }
                return
            }
            guard let safeData = data else {
                let alert = self.createAlert(alertReasonParam: .unknown)
                DispatchQueue.main.async {
                    self.setUIEnabled(true)
                    AppData.getSoundEnabledSettings(sound: Sound.negative)
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true)
                }
                return
            }
            
            DispatchQueue.main.async {
                for imageUrl in safeData {
                    let dataToSave = Photo(context: self.dataController.viewContext)
                    dataToSave.url = imageUrl
                    try? self.dataController.viewContext.save()
                }
                self.setupFetchedResultsController()
                
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
                
        getImagesUrls()
    }
    
    
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
    
    
    @IBAction func aboutPressed(_ sender: Any) {
        
        let version: String? = Bundle.main.infoDictionary![Constants.messages.appVersion] as? String
        let infoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let version = version {
            infoAlert.message = "\(Constants.messages.version) \(version)"
            infoAlert.title = Constants.messages.appName
        }
        
        infoAlert.modalPresentationStyle = .popover
        
        let cancelAction = UIAlertAction(title: Constants.messages.cancel, style: .cancel) {
            _ in
            self.dismiss(animated: true, completion: {
                SKStoreReviewController.requestReview()
            })
        }
        
        let shareAppAction = UIAlertAction(title: Constants.messages.shareApp, style: .default) {
            _ in
            self.shareApp()
        }
        
        let mailAction = UIAlertAction(title: Constants.messages.sendFeedback, style: .default) {
            _ in
            self.launchEmail()
        }
        
        let reviewAction = UIAlertAction(title: Constants.messages.leaveReview, style: .default) {
            _ in
            self.requestReviewManually()
        }
        
        let tutorialAction = UIAlertAction(title: Constants.messages.tutorial, style: .default) {
            _ in
            let storyboard = UIStoryboard(name: Constants.storyboardID.main, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: Constants.storyboardID.tutorial)
            self.present(controller, animated: true)
        }
        
        let settingsAction = UIAlertAction(title: Constants.messages.settings, style: .default) {
            _ in
            let storyboard = UIStoryboard(name: Constants.storyboardID.main, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: Constants.storyboardID.settings)
            self.present(controller, animated: true)
        }
        
        for action in [tutorialAction, settingsAction, mailAction, reviewAction, shareAppAction, cancelAction] {
            infoAlert.addAction(action)
        }
        
        if let presenter = infoAlert.popoverPresentationController {
            presenter.barButtonItem = aboutButton
        }
        
        present(infoAlert, animated: true)
    }
    
    
    func shareApp() {
        let message = Constants.messages.shareMessage
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: .unknown)
                self.present(alert, animated: true)
                return
            }
        }
        present(activityController, animated: true)
    }

}


extension PhotosViewController: MFMailComposeViewControllerDelegate {
    
    func launchEmail() {
        
        var emailTitle = Constants.messages.appName
        if let version = Bundle.main.infoDictionary![Constants.messages.appVersion] {
            emailTitle += " \(version)"
        }
        
        let messageBody = Constants.messages.emailSample
        let toRecipents = [Constants.messages.emailAddress]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var alert = UIAlertController()
        
        dismiss(animated: true, completion: {
            switch result {
            case MFMailComposeResult.failed:
                alert = self.createAlert(alertReasonParam: .messageFailed)
            case MFMailComposeResult.saved:
                alert = self.createAlert(alertReasonParam: .messageSaved)
            case MFMailComposeResult.sent:
                alert = self.createAlert(alertReasonParam: .messageSent)
            default:
                break
            }
            if let _ = alert.title {
                self.present(alert, animated: true)
            }
        })
    }
}

extension PhotosViewController {
    
    func requestReviewManually() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL
        
        guard let writeReviewURL = URL(string: Constants.messages.appReviewLink)
            else {
                fatalError("Expected a valid URL")
        }
        
        UIApplication.shared.open(writeReviewURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        
        
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
