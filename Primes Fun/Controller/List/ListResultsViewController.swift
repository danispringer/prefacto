//
//  ListResultsViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 08/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit


class ListResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var jumpToTopButton: UIButton!
    @IBOutlet weak var jumpToBottomButton: UIButton!
    @IBOutlet weak var myToolbar: UIToolbar!
    
    
    
    // MARK: Properties
    
    var source: [Int64]!
    var from: Int64!
    var to: Int64!
    let listCell = "ListCell"
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let myFrom = from, let myTo = to else {
            let alert = self.createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                AppData.getSoundEnabledSettings(sound: Sound.negative)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        
        if source.count == 0 {
            resultsTableView.isHidden = true
            jumpToTopButton.isHidden = true
            jumpToBottomButton.isHidden = true
            messageLabel.text = "There are no prime numbers between\n\n\(myFrom)\n\nand\n\n\(myTo)."
        } else {
            messageLabel.text = "From: \(myFrom)\nTo: \(myTo)\nPrimes: \(source.count)"
        }
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
    }
    
    
    // MARK: Helpers
    
    func jumpToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        resultsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
    }
    
    
    @IBAction func jumpToTopPressed(_ sender: Any) {
        jumpToTop()
    }
    
    
    @IBAction func jumpToBottomPressed(_ sender: Any) {
        let indexPath = IndexPath(row: resultsTableView.numberOfRows(inSection: 0) - 1, section: 0)
        resultsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
    @IBAction func share(_ sender: Any) {
        var message = ""
        
        guard let myFrom = from, let myTo = to else {
            let alert = createAlert(alertReasonParam: .unknown)
            present(alert, animated: true)
            return
        }
        
        guard source.count != 0 else {
            message = "Hey, did you know that there are no prime numbers between \(myFrom) and \(myTo)? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
            presentShareController(message: message)
            return
        }
        
        guard let mySource = source, let mySourceFirst = mySource.first, let mySourceLast = mySource.last else {
            let alert = createAlert(alertReasonParam: .unknown)
            present(alert, animated: true)
            return
        }
        
        if mySource.count == 1 {
            message = "Hey, did you know that the only prime number between \(myFrom) and \(myTo) is \(mySourceFirst)? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        } else if mySource.count == 2 {
            message = "Hey, did you know that the only two prime numbers between \(myFrom) and \(myTo) are \(mySourceFirst) and \(mySourceLast)? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        } else {
            let mySourceDroppedLast = mySource.dropLast()
            let stringMySourceDroppedLast = "\(mySourceDroppedLast)"
            let start = stringMySourceDroppedLast.index(stringMySourceDroppedLast.startIndex, offsetBy: 1)
            let end = stringMySourceDroppedLast.index(stringMySourceDroppedLast.endIndex, offsetBy: -1)
            let range = start..<end
            
            let cleanedMySourceDroppedLast = String(stringMySourceDroppedLast[range])
            message = "Hey, did you know that the prime numbers between \(myFrom) and \(myTo) are \(cleanedMySourceDroppedLast), and \(mySourceLast)? That's no less than \(mySource.count) numbers! I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        }
        
        presentShareController(message: message)
    }
    
    func presentShareController(message: String) {
        
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
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
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        SKStoreReviewController.requestReview()
    }
    
    
    // MARK: Delegates
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indicator = scrollView.subviews.last as? UIImageView
        indicator?.image = nil
        indicator?.backgroundColor = UIColor(red:0.93, green:0.90, blue:0.94, alpha:1.0)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: listCell) as! ListTableViewCell
        
        cell.numberLabel?.text = "\(source[(indexPath as NSIndexPath).row])"
        cell.selectionStyle = .none
        cell.numberLabel?.textColor = UIColor(red:0.93, green:0.90, blue:0.94, alpha:1.0)
        cell.numberLabel?.font = UIFont(name: Constants.messages.fontAmericanTypewriter, size: 25)
        
        cell.indexLabel?.text = "\(indexPath.row + 1)."
        cell.indexLabel?.textColor = UIColor(red:0.93, green:0.90, blue:0.94, alpha:1.0)
        cell.indexLabel?.font = UIFont(name: Constants.messages.fontAmericanTypewriter, size: 16)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(copy(_:)) {
            let cell = tableView.cellForRow(at: indexPath) as! ListTableViewCell
            let pasteboard = UIPasteboard.general
            pasteboard.string = cell.numberLabel?.text
        }
    }
    
}
