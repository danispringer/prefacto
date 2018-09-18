//
//  AppData.swift
//  Primes Fun
//
//  Created by Dani Springer on 23/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import AVFoundation

class AppData: UIViewController {
    
    static var soundEnabled: Bool = UserDefaults.standard.bool(forKey: "soundEnabled")
    
    static func getSoundEnabledSettings(sound: Int) {
        soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        
        if soundEnabled {
            playSound(sound: sound)
        }
    }
    
    static func setSoundEnabledSettings() {
        UserDefaults.standard.set(!soundEnabled, forKey: "soundEnabled")
    }
    
    static func playSound(sound: Int) {
        AudioServicesPlayAlertSound(SystemSoundID(sound))
    }
}
