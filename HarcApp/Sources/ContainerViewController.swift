//
//  FirstViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 01/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

protocol SearchSongIndexDelegate {
    func navigateToPage(index: Int)
}

class ContainerViewController: UIViewController, SearchSongIndexDelegate {
    
    var isExpanded = false
    let songStoryboard = UIStoryboard(name: "SongBook", bundle: nil)
    var controller: SongBookPageViewController!
    var aboutViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSongBookViewController()
    }
    
    func loadSongBookViewController() {
        self.title = "Śpiewnik"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Museo", size: 20)!]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        
        if controller != nil {
            self.view.bringSubviewToFront(controller.view)
            return
        }
        
        controller = songStoryboard.instantiateViewController(withIdentifier: "SongBookPageViewController") as? SongBookPageViewController
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    
    func loadAboutViewController() {
        
        if aboutViewController != nil {
            self.view.bringSubviewToFront(aboutViewController.view)
            self.title = aboutViewController.title
            return
        }
        
        aboutViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "essaViewController")
        
        self.view.addSubview(aboutViewController.view)
        self.addChild(aboutViewController)
        self.title = aboutViewController.title
        aboutViewController.didMove(toParent: self)
    }
    
    @objc func searchTapped() {
        print("search tapped")
        
        let searchSong = songStoryboard.instantiateViewController(withIdentifier: "searchSongViewController") as! SearchSongViewController
        searchSong.delegate = self
        
        let wrapper = UINavigationController(rootViewController: searchSong)
        
        present(wrapper, animated: true, completion: nil)
    }
    
    func navigateToPage(index: Int) {
        controller.goToPage(index: index)
    }
    
    func select(at index: Int) {
        clearNavigationBar()
        if index == 2 {
            loadSongBookViewController()
        } else if index == 1 {
            loadAboutViewController()
        }
    }
}

extension ContainerViewController {
    func clearNavigationBar() {
        self.title = ""
        self.navigationItem.rightBarButtonItem = nil
    }
}