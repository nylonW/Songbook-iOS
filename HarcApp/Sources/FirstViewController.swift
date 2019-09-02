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

class FirstViewController: UIViewController, SearchSongIndexDelegate {
    
    func navigateToPage(index: Int) {
        controller.goToPage(index: index)
    }
    
    var isExpanded = false
    let songStoryboard = UIStoryboard(name: "SongBook", bundle: nil)
    var controller: SongBookPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = songStoryboard.instantiateViewController(withIdentifier: "SongBookPageViewController") as? SongBookPageViewController
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
        self.title = "Śpiewnik"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Museo", size: 20)!]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
    }
    
    @objc func searchTapped() {
        print("search tapped")
        
        let searchSong = songStoryboard.instantiateViewController(withIdentifier: "searchSongViewController") as! SearchSongViewController
        searchSong.delegate = self
        
        let wrapper = UINavigationController(rootViewController: searchSong)
        
        present(wrapper, animated: true, completion: nil)
    }
}

