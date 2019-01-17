//
//  AppData.swift
//  Prime
//
//  Created by Daniel Springer on 23/07/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit
import AVFoundation


class AppData: UIViewController {


    static func getSoundEnabledSettings(sound: Int) {
        let soundEnabled = UserDefaults.standard.bool(forKey: Constants.UserDef.soundEnabled)
        if soundEnabled {
            playSound(sound: sound)
        }
    }


    static func playSound(sound: Int) {
        AudioServicesPlayAlertSound(SystemSoundID(sound))
    }


}
