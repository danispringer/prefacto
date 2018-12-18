//
//  SettingsViewControlller.swift
//  Primes Fun
//
//  Created by Daniel Springer on 23/07/2018.
//  Copyright © 2018 Daniel Springer. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var soundStateLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        soundSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.UserDefaultsStrings.soundEnabled)
    }

    // Helpers

    @IBAction func soundToggled(_ sender: Any) {
        UserDefaults.standard.set(soundSwitch.isOn, forKey: Constants.UserDefaultsStrings.soundEnabled)
        if soundSwitch.isOn {
            AppData.getSoundEnabledSettings(sound: Constants.Sound.toggle)
        }
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }

}
