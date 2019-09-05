//
//  EmotyFavouritesViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 04/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

class EmptyFavouritesViewController: UIViewController {

    @IBOutlet weak var hintLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkMode")
        
        if isDarkMode {
            hintLabel.textColor = .white
        } else {
            hintLabel.textColor = .black
        }
    }
}
