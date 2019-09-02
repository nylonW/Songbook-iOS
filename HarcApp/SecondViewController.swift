//
//  SecondViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 01/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit



class SecondViewController: UIViewController, RootViewControllerDelegate {

    var isExpanded = false
    
    var rootViewController: CenterNavigationController
    var drawerViewController: UITableViewController
    
    init(rootViewController: CenterNavigationController, drawerController: UITableViewController) {
        self.rootViewController = rootViewController
        self.drawerViewController = drawerController
        super.init(nibName: nil, bundle: nil)
        print(":))")
    }
    
    required init?(coder aDecoder: NSCoder) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        rootViewController = CenterNavigationController(mainViewController: storyboard.instantiateViewController(withIdentifier: "homeViewController"), topNavigationLeftImage: nil)
        drawerViewController = storyboard.instantiateViewController(withIdentifier: "drawerTableView") as! UITableViewController
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        self.view.addSubview(drawerViewController.view)
        addChild(drawerViewController)
        drawerViewController.didMove(toParent: self)
        
        self.view.addSubview(rootViewController.view)
        addChild(rootViewController)
        rootViewController.didMove(toParent: self)
        
        self.rootViewController.drawerDelegate = self
    }

    func rootViewControllerDidTapMenuButton(rootViewController: CenterNavigationController) {
        print("papped")
        UIView.animate(withDuration: 0.3, animations: {
            if !self.isExpanded {
                rootViewController.view.frame.origin.x = self.view.frame.width / 1.3
            } else {
                rootViewController.view.frame.origin.x = 0
            }
            self.isExpanded.toggle()
        })
    }

}

