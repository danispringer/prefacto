//
//  ListResultsViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 08/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ListResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    
    
    
    // MARK: Properties
    
    var source: [Int64]!
    var from: Int64!
    var to: Int64!
    
    
    let positiveSound: Int = 1023
    let negativeSound: Int = 1257
    
    
    // MARK: Life Cycle
    
    
    
    // MARK: Helpers
    
    @IBAction func share(_ sender: Any) {
        var message = ""
        
        guard let myFrom = from, let myTo = to, let mySource = source, let mySourceFirst = mySource.first, let mySourceLast = source.last else {
            // alert user: unknown
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            present(alert, animated: true)
            return
        }

        if mySource.count == 0 {
            message = "Hey, did you know that there are no prime numbers between \(myFrom) and \(myTo)? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        }
        if mySource.count == 1 {
            message = "Hey, did you know that the only prime number between \(myFrom) and \(to!) is \(mySourceFirst)? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        } else { // TODO: a, b, c, and d
            let mySourceDroppedLast = mySource.dropLast()
            let stringMySourceDroppedLast = "\(mySourceDroppedLast)"
            let start = stringMySourceDroppedLast.index(stringMySourceDroppedLast.startIndex, offsetBy: 1)
            let end = stringMySourceDroppedLast.index(stringMySourceDroppedLast.endIndex, offsetBy: -1)
            let range = start..<end
            
            let cleanedMySourceDroppedLast = String(stringMySourceDroppedLast[range])
            message = "Hey, did you know that the prime numbers between \(myFrom) and \(myTo) are \(cleanedMySourceDroppedLast), and \(mySourceLast)? That's no less than \(mySource.count) numbers! I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        }
        
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown.rawValue)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true)
                    AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
                }
                return
            }
        }
        self.present(activityController, animated: true)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell")!
        
        cell.textLabel?.text = "\(source[(indexPath as NSIndexPath).row])"
        cell.selectionStyle = .none
        
        return cell
    }
    
}
