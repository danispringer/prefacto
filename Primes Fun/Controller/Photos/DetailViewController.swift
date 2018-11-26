//
//  DetailViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 24/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit


class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    
    // MARK: Outlets
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var myToolbar: UIToolbar!
    
    
    // MARK: Properties
    
    var myImage: UIImage! = nil
    
    
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
        
        myScrollView.minimumZoomScale = 1.0
        myScrollView.maximumZoomScale = 6.0
        
        detailImage.isUserInteractionEnabled = true
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        
        doubleTap.delegate = self as? UIGestureRecognizerDelegate
        doubleTap.numberOfTapsRequired = 2
        detailImage.addGestureRecognizer(doubleTap)
    }
    
    
    // MARK: Helpers
    
    @objc func doubleTapped() {
        if myScrollView.zoomScale == myScrollView.minimumZoomScale {
            myScrollView.setZoomScale(myScrollView.maximumZoomScale, animated: true)
        } else {
            myScrollView.setZoomScale(myScrollView.minimumZoomScale, animated: true)
        }
    }
    
    
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
                let alert = self.createAlert(alertReasonParam: .unknown)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true)
                    AppData.getSoundEnabledSettings(sound: Sound.negative)
                }
                return
            }
        }
        self.present(activityController, animated: true)
    }
    
    
    @IBAction func downloadPressed(_ sender: Any) {
        
        guard detailImage.image != nil else {
            let alert = createAlert(alertReasonParam: .unknown)
            present(alert, animated: true)
            return
        }
        
        let image = detailImage.image!
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)

    }
    
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            let alert = createAlert(alertReasonParam: .permissionDenied)
            let goToSettingsButton = UIAlertAction(title: Constants.messages.openSettings, style: .default, handler: {
                action in
                if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
                    UIApplication.shared.open(url)
                }
            })
            alert.addAction(goToSettingsButton)
            present(alert, animated: true)
            return
        }
        let alert = createAlert(alertReasonParam: .imageSaved)
        let goToLibraryButton = UIAlertAction(title: Constants.messages.openGallery, style: .default, handler: {
            action in
            UIApplication.shared.open(URL(string: Constants.messages.galleryLink)!)
        })
        alert.addAction(goToLibraryButton)
        present(alert, animated: true)
    }
    
    
    // MARK: ScrollView Delegates
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return detailImage
    }
    
}
