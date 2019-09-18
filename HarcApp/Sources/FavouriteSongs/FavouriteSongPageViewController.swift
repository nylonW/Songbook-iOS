//
//  FavouriteSongPageViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 04/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

class FavouriteSongPageViewController: UIPageViewController, SearchSongIndexDelegate {
    
    var vcs: [UIViewController] = []
    let songStoryboard = UIStoryboard(name: "SongBook", bundle: nil)
    var favouriteSongs: [String] = []
    var isDarkMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        // Do any additional setup after loading the view.
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        //goToPage(index: 90)
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Museo", size: 20)!]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("fav_manage", comment: ""), style: .plain, target: self, action: #selector(showManageViewController))
    }
    
    @objc func showManageViewController() {
        let manageController = UIStoryboard(name: "ManageFavourites", bundle: nil).instantiateInitialViewController()
        self.navigationController?.pushViewController(manageController!, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isDarkMode = UserDefaults.standard.bool(forKey: "darkMode")
        
        if isDarkMode {
            self.view.backgroundColor = .black
        } else {
            self.view.backgroundColor = .white
        }

        if favouriteSongs != UserDefaults.standard.stringArray(forKey: "favouriteSongs") ?? [] {
            favouriteSongs = UserDefaults.standard.stringArray(forKey: "favouriteSongs") ?? []
            
            reloadViews()
            orderedViewControllers = []
            orderedViewControllers = reloadViewControllers()
            if orderedViewControllers.count == 0 {
                orderedViewControllers = [songStoryboard.instantiateViewController(withIdentifier: "emptyFavouritesViewController")]
            }
            
            if let firstViewController = orderedViewControllers.first {
                setViewControllers([firstViewController],
                                   direction: .forward,
                                   animated: false,
                                   completion: nil)
            }
            
            reloadViews()
        }
    }
    
    @objc func searchTapped() {
        let searchSong = songStoryboard.instantiateViewController(withIdentifier: "searchSongViewController") as! SearchSongViewController
        searchSong.delegate = self
        
        let wrapper = UINavigationController(rootViewController: searchSong)
        
        present(wrapper, animated: true, completion: nil)
    }
    
    func navigateToPage(index: Int) {
        goToPage(index: index)
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        favouriteSongs = UserDefaults.standard.stringArray(forKey: "favouriteSongs") ?? []
        
        for file in favouriteSongs {
            vcs.append(self.newSongViewController(song: SongManager.shared().songs.filter({ $0.fileName == file }).first!))
        }
        
        if vcs.count == 0 {
            vcs.append(songStoryboard.instantiateViewController(withIdentifier: "emptyFavouritesViewController"))
        }
        
        return vcs
    }()
    
    private func reloadViewControllers() -> [UIViewController] {
        vcs = []
        
        for file in favouriteSongs {
            vcs.append(self.newSongViewController(song: SongManager.shared().songs.filter({ $0.fileName == file }).first!))
        }
        
        return vcs
    }
    
    private func newSongViewController(song: Song) -> UIViewController {
        let songViewController = UIStoryboard(name: "SongBook", bundle: nil).instantiateViewController(withIdentifier: "SongViewController") as! SongViewController
        songViewController.song = song
        songViewController.fromFavourites = true
        return songViewController
    }
    
    func goToPage(index: Int) {
        if index < vcs.count {
            self.setViewControllers([vcs[index]], direction: .forward, animated: true, completion: nil)
            
            reloadViews()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        let controller = pendingViewControllers.first as! SongViewController
        controller.setDarkMode()
        controller.setShowChords()
    }
}

extension FavouriteSongPageViewController: UIPageViewControllerDataSource {
    
    func reloadViews() {
        self.dataSource = nil
        self.dataSource = self
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}
