//
//  FavouriteOrderViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 12/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

class ManageFavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var favouriteSongs: [String] = []
    var songs: [Song] = []
    
    let searchCellId = "SearchSongTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupFavourites()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.isEditing = false
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: searchCellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: searchCellId)
        tableView.isEditing = true
    }
    
    func setupFavourites() {
        favouriteSongs = UserDefaults.standard.stringArray(forKey: "favouriteSongs") ?? []
        songs = []
        
        for file in favouriteSongs {
            songs.append(SongManager.shared().songs.filter({ $0.fileName == file }).first!)
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellId) as! SearchSongTableViewCell
        cell.song = songs[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            songs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveSongs()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = songs[sourceIndexPath.row]
        songs.remove(at: sourceIndexPath.row)
        songs.insert(rowToMove, at: destinationIndexPath.row)
        saveSongs()
        
        print(favouriteSongs)
    }
    
    func saveSongs() {
        favouriteSongs = songs.map({ $0.fileName })
        UserDefaults.standard.set(favouriteSongs, forKey: "favouriteSongs")
    }
}
