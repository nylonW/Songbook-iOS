//
//  FirstViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 01/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var isExpanded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "SongBook", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SongBookPageViewController")
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }

}

