//
//  DetailViewController.swift
//  Primes Fun
//
//  Created by Daniel Springer on 24/06/2018.
//  Copyright © 2018 Daniel Springer. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit


class DetailViewController: UIViewController, UIScrollViewDelegate {


    // MARK: Outlets

    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var shareButtonItem: UIBarButtonItem!


    // MARK: Properties

    var myImage: UIImage! = nil


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = CGRect(x: 0,
                                          y: myToolbar.frame.midY,
                                          width: view.bounds.width, height: view.bounds.height)
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            view.insertSubview(blurEffectView, at: 0)
        } else {
            view.backgroundColor = .black
        }

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
        dismiss(animated: false, completion: nil)
        SKStoreReviewController.requestReview()
    }


    @IBAction func shareButtonPressed(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [detailImage.image!],
                                                          applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = shareButtonItem
        activityController.popoverPresentationController?.permittedArrowDirections = []
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: .unknown)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true)
                    AppData.getSoundEnabledSettings(sound: Constants.Sound.negative)
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
            let goToSettingsButton = UIAlertAction(title: Constants.Messages.openSettings,
                                                   style: .default, handler: { _ in
                if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
                    UIApplication.shared.open(url)
                }
            })
            alert.addAction(goToSettingsButton)
            present(alert, animated: true)
            return
        }
        let alert = createAlert(alertReasonParam: .imageSaved)
        let goToLibraryButton = UIAlertAction(title: Constants.Messages.openGallery, style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: Constants.Messages.galleryLink)!)
        })
        alert.addAction(goToLibraryButton)
        present(alert, animated: true)
    }


    // MARK: ScrollView Delegates

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return detailImage
    }


}
