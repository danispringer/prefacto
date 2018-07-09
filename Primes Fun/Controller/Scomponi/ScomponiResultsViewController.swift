//
//  ScomponiResultsViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 09/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ScomponiResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var numberLabel: UILabel!
    
    
    // MARK: Properties
    
    var source: [Int64]!
    var number: Int64!
    
    let positiveSound: Int = 1023
    let negativeSound: Int = 1257
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        if let myNumber = number {
            numberLabel.text = "\(myNumber)"
        } else {
            numberLabel.text = "Could not display chosen number. Please let the developers know."
        }
    }
    
    
    // MARK: Helpers
    
    @IBAction func share(_ sender: Any) {
        var message = ""
        
        guard let myNumber = number, let mySource = source, let mySourceFirst = mySource.first, let mySourceLast = mySource.last else {
            // TODO: alert user
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            present(alert, animated: true)
            return
        }
        
        if source.count == 1 {
            message = "Hey, did you know that \(myNumber) is a prime number? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        } else if source.count == 2 {
            message = "Hey, did you know that the prime factors of \(myNumber) are \(mySourceFirst) and \(mySourceLast)? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        } else {
            let mySourceDroppedLast = mySource.dropLast()
            let stringMySourceDroppedLast = "\(mySourceDroppedLast)"
            let start = stringMySourceDroppedLast.index(stringMySourceDroppedLast.startIndex, offsetBy: 1)
            let end = stringMySourceDroppedLast.index(stringMySourceDroppedLast.endIndex, offsetBy: -1)
            let range = start..<end
            
            let cleanedMySourceDroppedLast = String(stringMySourceDroppedLast[range])

            message = "Hey, did you know that the prime factors of \(myNumber) are \(cleanedMySourceDroppedLast), and \(mySourceLast)? That's no less than \(mySource.count) numbers! I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        }
        
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown.rawValue)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                    AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
                }
                return
            }
        }
        present(activityController, animated: true)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FactorCell")!
        
        cell.textLabel?.text = "\(source[(indexPath as NSIndexPath).row])"
        cell.selectionStyle = .none
        
        return cell
    }
    
}
