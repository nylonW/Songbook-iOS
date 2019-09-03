//
//  CenterNavigationController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 01/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

protocol RootViewControllerDelegate: class {
    func rootViewControllerDidTapMenuButton(rootViewController: CenterNavigationController)
    func enableDarkMode(enable: Bool)
}

class CenterNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    var drawerDelegate: RootViewControllerDelegate?
    fileprivate var menuButton: UIBarButtonItem!
    
    var isExpanded = false
    
    public init(mainViewController: UIViewController, topNavigationLeftImage: UIImage?) {
        super.init(rootViewController: mainViewController)
        menuButton = UIBarButtonItem(image: topNavigationLeftImage, style: .plain, target: self, action: #selector(tapped))
        menuButton.title = "☰"
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    @objc func tapped() {        
        //drawerDelegate?.rootViewControllerDidTapMenuButton(rootViewController: self)
        
        enableDarkMode()
    }
    var darkMode = false
    
    func enableDarkMode() {
        darkMode = true
        UIView.animate(withDuration: 1, animations: {
            self.navigationBar.barTintColor = .black
            
            if var textAttributes = self.navigationBar.titleTextAttributes {
                textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
                self.navigationBar.titleTextAttributes = textAttributes
            }
            
            self.navigationBar.layoutIfNeeded()
        })
        
        drawerDelegate?.enableDarkMode(enable: darkMode)
        navigationBar.tintColor = .white
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        prepareNavigationBar()
    }
}

extension CenterNavigationController {
    fileprivate func prepareNavigationBar() {
        topViewController?.navigationItem.title = topViewController?.title
        if self.viewControllers.count <= 1 {
            topViewController?.navigationItem.leftBarButtonItem = menuButton
        }
    }
}
