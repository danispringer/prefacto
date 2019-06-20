//
//  SettingsViewControlller.swift
//  Prime
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

        myTableView.rowHeight = UITableView.automaticDimension

        //setTheme()
    }


    // Helpers

//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//
//        setTheme()
//    }


    @objc func showSeparatorToggled(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constants.UserDef.showSeparator)
    }


    @objc func iconSetterToggled(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constants.UserDef.iconIsDark)
        setIcon()
    }


    func setIcon() {
        let newIcon = UserDefaults.standard.bool(forKey: Constants.UserDef.iconIsDark) ?
            Constants.UserDef.dark : Constants.UserDef.light

        guard UIApplication.shared.supportsAlternateIcons else {
            print("NOTE: alternate icons not supported")
            return
        }

        UIApplication.shared.setAlternateIconName(newIcon) { error in
            if let error = error {
                print("App icon failed to change due to \(error.localizedDescription)")
            } else {
                print("app icon should now be updated")
            }
        }
    }


//    func setTheme() {
//        let darkMode = traitCollection.userInterfaceStyle == .dark
//    }


    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    // MARK: Delegates

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        tableView.backgroundColor = UIColor.systemBackground
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCell)
        cell?.selectionStyle = .none
        cell?.textLabel?.textColor = UIColor.label
        cell?.backgroundColor = UIColor.systemBackground
        cell?.contentView.backgroundColor = UIColor.systemBackground
        cell?.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)

        switch indexPath.row {
        case 0:
            let mySeparatorSwitch = UISwitch()
            mySeparatorSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.UserDef.showSeparator)
            cell?.accessoryView = mySeparatorSwitch
            mySeparatorSwitch.addTarget(self,
                                        action: #selector(showSeparatorToggled(sender:)),
                                        for: .valueChanged)
            cell?.textLabel?.text = "Thousands Separator"
        case 1:
            let myIconSwitch = UISwitch()
            myIconSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.UserDef.iconIsDark)
            cell?.accessoryView = myIconSwitch
            myIconSwitch.addTarget(self, action: #selector(iconSetterToggled(sender:)), for: .valueChanged)
            cell?.textLabel?.text = "App Icon (Light/Dark)"

        default:
            break
        }

        return cell ?? UITableViewCell()
    }

}
