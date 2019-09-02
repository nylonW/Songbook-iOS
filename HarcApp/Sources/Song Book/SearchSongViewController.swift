//
//  SearchSongViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 02/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

class SearchSongViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    let searchCellId = "SearchSongTableViewCell"
    var delegate: SearchSongIndexDelegate?
    var searchController: UISearchController!
    var filteredSongs: [Song] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: searchCellId, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: searchCellId)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Wyszukaj piosenkę"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.becomeFirstResponder()
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        filteredSongs = SongManager.shared().songs
    }
    
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentSearchText(_ searchText: String, scope: String = "All") {
        filteredSongs = SongManager.shared().songs.filter({ (song: Song) -> Bool in
            return song.title.lowercased().folding(options: .diacriticInsensitive, locale: .current).contains(searchText.lowercased().folding(options: .diacriticInsensitive, locale: .current))
        })
        
        tableView.reloadData()
    }
}

extension SearchSongViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellId) as! SearchSongTableViewCell
        cell.song = filteredSongs[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSong = filteredSongs[indexPath.row]
        let currentSongIndex = SongManager.shared().songs.firstIndex(where: {$0.fileName == currentSong.fileName})
        delegate?.navigateToPage(index: currentSongIndex ?? 0)
        
        self.searchController.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
