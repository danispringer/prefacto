//
//  SettingsViewControlller.swift
//  Primes Fun
//
//  Created by Dani Springer on 23/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var soundStateLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!
    
    
    // MARK: Properties
    
    let toggleSound = 1104
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        soundSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.messages.soundEnabled)
    }
    
    
    // Helpers
    
    @IBAction func soundToggled(_ sender: Any) {
        UserDefaults.standard.set(soundSwitch.isOn, forKey: Constants.messages.soundEnabled)
        if soundSwitch.isOn {
            AppData.getSoundEnabledSettings(sound: self.toggleSound)
            
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
