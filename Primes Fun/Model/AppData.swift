//
//  AppData.swift
//  Primes Fun
//
//  Created by Daniel Springer on 23/07/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit
import AVFoundation


class AppData: UIViewController {


    static var soundEnabled: Bool = UserDefaults.standard.bool(forKey: Constants.UserDefaultsStrings.soundEnabled)


    static func getSoundEnabledSettings(sound: Int) {
        soundEnabled = UserDefaults.standard.bool(forKey: Constants.UserDefaultsStrings.soundEnabled)
        if soundEnabled {
            playSound(sound: sound)
        }
    }


    static func setSoundEnabledSettings() {
        UserDefaults.standard.set(!soundEnabled, forKey: Constants.UserDefaultsStrings.soundEnabled)
    }


    static func playSound(sound: Int) {
        AudioServicesPlayAlertSound(SystemSoundID(sound))
    }


}
