//
//  SongBookPageViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 01/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

protocol SearchSongIndexDelegate {
    func navigateToPage(index: Int)
}

class SongBookPageViewController: UIPageViewController, SearchSongIndexDelegate, UIPopoverPresentationControllerDelegate, PresentSearchControllerDelegate {
    
    var vcs: [UIViewController] = []
    let songStoryboard = UIStoryboard(name: "SongBook", bundle: nil)
    var isDarkMode = false
    var fastSettingsButton: UIBarButtonItem!
    
    var currentSong: Song?

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
        
        self.title = NSLocalizedString("songbook", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Museo", size: 20)!]
        
        let settings = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-settings-50.png"), style: .plain, target: self, action: #selector(showSettings))
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTappedPlain)), settings]
        
        fastSettingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "moreicon"), style: .plain, target: self, action: #selector(quickSettings))
        self.navigationItem.leftBarButtonItem = fastSettingsButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isDarkMode = UserDefaults.standard.bool(forKey: "darkMode")
        
        if isDarkMode {
            self.view.backgroundColor = .black
        } else {
            self.view.backgroundColor = .white
        }
    }
    
    @objc func quickSettings() {
        let popupStoryboard = UIStoryboard(name: "Popup", bundle: nil)
        let popupVC = popupStoryboard.instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        let leftButtonView = fastSettingsButton.value(forKey: "view") as? UIView
        
        popupVC.modalPresentationStyle = UIModalPresentationStyle.popover
        if isDarkMode {
            popupVC.popoverPresentationController?.backgroundColor = Constants.Colors.darkSecondary
        }
        popupVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popupVC.popoverPresentationController?.delegate = self
        popupVC.popoverPresentationController?.sourceView = leftButtonView
        popupVC.popoverPresentationController?.sourceRect = leftButtonView!.bounds
        popupVC.preferredContentSize = CGSize(width: view.frame.size.width - 20, height: (view.frame.size.width * 0.75) / 2)
        popupVC.song = (self.viewControllers?.first as! SongViewController).song
        
        self.present(popupVC, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
    
    @objc func showSettings() {
        let settingsViewController = songStoryboard.instantiateViewController(withIdentifier: "settingsViewController")
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @objc func searchTapped(text: String?) {
        let searchSong = songStoryboard.instantiateViewController(withIdentifier: "searchSongViewController") as! SearchSongViewController
        searchSong.delegate = self
        searchSong.text = text
        
        let wrapper = UINavigationController(rootViewController: searchSong)
        
        present(wrapper, animated: true, completion: nil)
    }
    
    @objc func searchTappedPlain() {
        let searchSong = songStoryboard.instantiateViewController(withIdentifier: "searchSongViewController") as! SearchSongViewController
        searchSong.delegate = self
        
        let wrapper = UINavigationController(rootViewController: searchSong)
        
        present(wrapper, animated: true, completion: nil)
    }
    
    func presentSearchController(withText: String) {
        searchTapped(text: withText)
    }
    
    func navigateToPage(index: Int) {
        goToPage(index: index)
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        for song in SongManager.shared().songs {
            vcs.append(newSongViewController(song: song))
        }
        
        return vcs
    }()
    
    private func newSongViewController(song: Song) -> UIViewController {
        let songViewController = UIStoryboard(name: "SongBook", bundle: nil).instantiateViewController(withIdentifier: "SongViewController") as! SongViewController
        songViewController.song = song
        songViewController.delegate = self
        
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

extension SongBookPageViewController: UIPageViewControllerDataSource {
    
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
