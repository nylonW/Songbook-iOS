//
//  SecondViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 01/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

protocol ManageDrawerDelegate {
    func select(at index: Int)
    func closeDrawer()
}

class DrawerController: UIViewController, RootViewControllerDelegate, ManageDrawerDelegate {

    var isExpanded = false
    
    var rootViewController: CenterNavigationController
    var drawerViewController: DrawerTableViewController
    var containerViewController: ContainerViewController!
    
    init(rootViewController: CenterNavigationController, drawerController: DrawerTableViewController) {
        self.rootViewController = rootViewController
        self.drawerViewController = drawerController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        containerViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as? ContainerViewController
        rootViewController = CenterNavigationController(mainViewController: containerViewController, topNavigationLeftImage: nil)
        drawerViewController = storyboard.instantiateViewController(withIdentifier: "drawerTableView") as! DrawerTableViewController
        super.init(coder: aDecoder)
        
        drawerViewController.delegate = self
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
    
    func select(at index: Int) {
        containerViewController.select(at: index)
    }
    
    func closeDrawer() {
        UIView.animate(withDuration: 0.3, animations: {
            self.rootViewController.view.frame.origin.x = 0
            self.isExpanded = false
        })
    }

    func rootViewControllerDidTapMenuButton(rootViewController: CenterNavigationController) {
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

