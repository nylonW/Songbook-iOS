//
//  SongBookPageViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 01/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

class SongBookPageViewController: UIPageViewController {
    var vcs: [UIViewController] = []

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
    }
    

    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        for song in SongManager.shared().songs {
            vcs.append(self.newSongViewController(song: song))
        }
        
        return vcs
    }()
    
    private func newSongViewController(song: Song) -> UIViewController {
        let songViewController = UIStoryboard(name: "SongBook", bundle: nil).instantiateViewController(withIdentifier: "SongViewController") as! SongViewController
        songViewController.song = song
        return songViewController
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     
    */
    
    func goToPage(index: Int) {
        if index < vcs.count {
            self.setViewControllers([vcs[index]], direction: .forward, animated: true, completion: nil)
            
            reloadViews()
        }
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
