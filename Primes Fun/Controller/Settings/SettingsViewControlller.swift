//
//  SettingsViewControlller.swift
//  Primes Fun
//
//  Created by Daniel Springer on 23/07/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    // MARK: Outlets

    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var myTableView: UITableView!


    // MARK: Properties

    let settingsCell = "SettingsCell"


    // MARK: Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

        setTheme()
    }


    // Helpers

    @objc func soundToggled(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constants.UserDef.soundEnabled)
        if sender.isOn {
            AppData.getSoundEnabledSettings(sound: Constants.Sound.toggle)
        }
    }


    @objc func themeToggled(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constants.UserDef.darkModeEnabled)
        setTheme()
    }


    func setTheme() {
        let darkMode = UserDefaults.standard.bool(forKey: Constants.UserDef.darkModeEnabled)
        view.backgroundColor = darkMode ? .black : .white
        myToolbar.tintColor = darkMode ? Constants.View.goldColor : Constants.View.blueColor
        myTableView.reloadData()
    }


    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    // MARK: Delegates

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let darkMode = UserDefaults.standard.bool(forKey: Constants.UserDef.darkModeEnabled)
        tableView.backgroundColor = darkMode ? .black : .white
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCell)
        cell?.selectionStyle = .none
        cell?.textLabel?.textColor = darkMode ? .white : .black
        cell?.backgroundColor = darkMode ? .black : .white
        cell?.contentView.backgroundColor = darkMode ? .black : .white
        cell?.textLabel?.font = UIFont(name: Constants.Font.math, size: 30)

        switch indexPath.row {
        case 0:
            let mySoundSwitch = UISwitch()
            mySoundSwitch.onTintColor = darkMode ? Constants.View.goldColor : Constants.View.greenColor
            mySoundSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.UserDef.soundEnabled)
            cell?.accessoryView = mySoundSwitch
            mySoundSwitch.addTarget(self,
                                    action: #selector(soundToggled(sender:)),
                                    for: .valueChanged)
            cell?.textLabel?.text = "Sound:"
        case 1:
            let myThemeSwitch = UISwitch()
            myThemeSwitch.onTintColor = darkMode ? Constants.View.goldColor : Constants.View.greenColor
            myThemeSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.UserDef.darkModeEnabled)
            cell?.accessoryView = myThemeSwitch
            myThemeSwitch.addTarget(self,
                                    action: #selector(themeToggled(sender:)),
                                    for: .valueChanged)
            cell?.textLabel?.text = "Dark Mode:"
        default:
            break
        }

        return cell ?? UITableViewCell()
    }

}
