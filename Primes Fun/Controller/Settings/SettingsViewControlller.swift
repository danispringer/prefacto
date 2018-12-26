//
//  SettingsViewControlller.swift
//  Primes Fun
//
//  Created by Daniel Springer on 23/07/2018.
//  Copyright © 2018 Daniel Springer. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    // MARK: Outlets

    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var myTableView: UITableView!


    // MARK: Properties

    let settingsCell = "SettingsCell"


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }


    // Helpers

    @objc func soundToggled(sender: UISwitch) {
        print("soundToggled Called")
        UserDefaults.standard.set(sender.isOn, forKey: Constants.UserDefaultsStrings.soundEnabled)
        if sender.isOn {
            AppData.getSoundEnabledSettings(sound: Constants.Sound.toggle)
        }
    }


    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    // MARK: Delegates

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCell)
        cell?.selectionStyle = .none
        cell?.textLabel?.textColor = .white
        cell?.textLabel?.font = UIFont(name: Constants.Font.math, size: 30)

        switch indexPath.row {
        case 0:
            let mySoundSwitch = UISwitch()
            mySoundSwitch.onTintColor = Constants.View.goldColor
            mySoundSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.UserDefaultsStrings.soundEnabled)
            cell?.accessoryView = mySoundSwitch

            mySoundSwitch.addTarget(self,
                                    action: #selector(soundToggled(sender:)),
                                    for: .valueChanged)
            cell?.textLabel?.text = "Sound:"
        default:
            break
        }

        return cell ?? UITableViewCell()
    }

}
