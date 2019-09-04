//
//  SettingsTableViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 04/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var showChordsSwitch: UISwitch!
    
    var isDarkMode = false
    var showChords = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isDarkMode = UserDefaults.standard.bool(forKey: "darkMode")
        showChords = UserDefaults.standard.bool(forKey: "showChords")
        
        darkModeSwitch.setOn(isDarkMode, animated: true)
        showChordsSwitch.setOn(showChords, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            
        }
    }
    
    @IBAction func darkModeDidSwitch(_ sender: UISwitch) {
        isDarkMode = darkModeSwitch.isOn
        UserDefaults.standard.set(isDarkMode, forKey: "darkMode")
        if isDarkMode {
            UITableView.appearance().backgroundColor = .black
            UITableViewCell.appearance().backgroundColor = Constants.Colors.darkSecondary
            UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = .white
            UINavigationBar.appearance().barTintColor = .black
            UINavigationBar.appearance().barStyle = .black
            UINavigationBar.appearance().tintColor = .white
            UITableView.appearance().separatorColor = UIColor(red:0.14, green:0.14, blue:0.15, alpha:1.0)
            UITabBar.appearance().barTintColor = Constants.Colors.darkSecondary
            UITabBar.appearance().tintColor = .white
            
            UIView.animate(withDuration: 0.6, animations: {
                self.resetViews()
            })
            
        } else {
            UINavigationBar.appearance().barTintColor = .white
            UINavigationBar.appearance().barStyle = .default
            UINavigationBar.appearance().tintColor = .systemBlue
            UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = .black
            UITableView.appearance().backgroundColor = .groupTableViewBackground
            UITableViewCell.appearance().backgroundColor = .white
            UITableView.appearance().separatorColor = UITableView().separatorColor
            UITabBar.appearance().barTintColor = UITabBar().barTintColor
            UITabBar.appearance().tintColor = .systemBlue
            
            UIView.animate(withDuration: 0.6, animations: {
                self.resetViews()
            })
        }
    }
    
    public func resetViews() {
        let windows = UIApplication.shared.windows as [UIWindow]
        for window in windows {
            let subviews = window.subviews as [UIView]
            for v in subviews {
                v.removeFromSuperview()
                window.addSubview(v)
            }
        }
    }
    
    
    @IBAction func showChordsDidSwitch(_ sender: Any) {
        
    }
}
