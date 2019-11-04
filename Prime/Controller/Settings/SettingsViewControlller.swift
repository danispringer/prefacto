//
//  SettingsViewControlller.swift
//  Prime
//
//  Created by Daniel Springer on 23/07/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {


    // MARK: Outlets

    @IBOutlet weak var thousandsSeparatorSwitch: UISwitch!
    @IBOutlet weak var iconSegmentedControl: UISegmentedControl!


    // MARK: Properties

    let settingsCell = "SettingsCell"


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        thousandsSeparatorSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.UserDef.showSeparator)
        iconSegmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(
            forKey: Constants.UserDef.selectedIcon)

    }


    // Helpers

    @IBAction func showSeparatorToggled(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constants.UserDef.showSeparator)
    }


    @IBAction func updateIcon(sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: Constants.UserDef.selectedIcon)
        setIcon()
    }


    func setIcon() {

        var myIcon = ""

        switch UserDefaults.standard.integer(forKey: Constants.UserDef.selectedIcon) {
        case 0:
            myIcon = Constants.UserDef.dark
        case 1:
            myIcon = Constants.UserDef.light
        default:
            myIcon = Constants.UserDef.dark
        }

        guard UIApplication.shared.supportsAlternateIcons else {
            print("Alternate icons not supported")
            return
        }

        UIApplication.shared.setAlternateIconName(myIcon) { error in
            if let error = error {
                print("App icon failed to change due to \(error.localizedDescription)")
            }
        }
    }


    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
