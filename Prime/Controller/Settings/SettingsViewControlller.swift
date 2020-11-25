//
//  SettingsViewControlller.swift
//  Prime
//
//  Created by Daniel Springer on 23/07/2018.
//  Copyright © 2020 Daniel Springer. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {


    // MARK: Outlets

    @IBOutlet weak var thousandsSeparatorSwitch: UISwitch!
    @IBOutlet weak var iconSegmentedControl: UISegmentedControl!


    // MARK: Properties

    let settingsCell = "SettingsCell"
    let options = ["light-setting", "dark-setting"]


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        thousandsSeparatorSwitch.isOn = UDStan.bool(forKey: Const.UserDef.showSeparator)
        iconSegmentedControl.selectedSegmentIndex = UDStan.integer(
            forKey: Const.UserDef.selectedIcon)

        for (index, imageName) in options.enumerated() {
            iconSegmentedControl.setImage(UIImage(named: imageName), forSegmentAt: index)
        }

    }


    // Helpers

    @IBAction func showSeparatorToggled(sender: UISwitch) {
        UDStan.set(sender.isOn, forKey: Const.UserDef.showSeparator)
    }


    @IBAction func updateIcon(sender: UISegmentedControl) {
        UDStan.set(sender.selectedSegmentIndex, forKey: Const.UserDef.selectedIcon)
        setIcon()
    }


    func setIcon() {

        var myIcon = ""

        switch UDStan.integer(forKey: Const.UserDef.selectedIcon) {
        case 0:
            myIcon = Const.UserDef.light
        case 1:
            myIcon = Const.UserDef.dark
        default:
            myIcon = Const.UserDef.light
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
