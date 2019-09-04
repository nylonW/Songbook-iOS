//
//  AppDelegate.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 01/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UserDefaults.standard.register(defaults: ["showChords": true])
        
        print(SongManager.shared())
        setupGlobalAppearance()
        
        UIApplication.shared.isIdleTimerDisabled = true
        return true
    }
    
    func setupGlobalAppearance(){
        let customFont = Constants.fonts.museo
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: customFont!], for: .normal)
        UITextField.appearance().font = customFont
        
        if UserDefaults.standard.bool(forKey: "darkMode") {
            UITableView.appearance().backgroundColor = .black
            UITableViewCell.appearance().backgroundColor = Constants.Colors.darkSecondary
            UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = .white
            UINavigationBar.appearance().barTintColor = .black
            UINavigationBar.appearance().barStyle = .black
            UINavigationBar.appearance().tintColor = .white
            UITableView.appearance().separatorColor = UIColor(red:0.14, green:0.14, blue:0.15, alpha:1.0)
            UITabBar.appearance().barTintColor = Constants.Colors.darkSecondary
            UITabBar.appearance().tintColor = .white
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
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

