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
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: searchCellId, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: searchCellId)
        
        setupSearchController()
        setupKeyboardObservers()
        
        let doneButton = UIBarButtonItem(title: "Gotowe", style: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = doneButton
        filteredSongs = SongManager.shared().songs
        
        
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Wyszukaj piosenkę"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let textFieldInsideUISearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.font = Constants.fonts.museo
        
        // SearchBar placeholder
        let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideUISearchBarLabel?.font = Constants.fonts.museo
    }
    

    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        UIView.animate(withDuration: 2, animations: {
            self.tableViewBottomConstraint.constant = keyboardHeight
            self.tableView.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        UIView.animate(withDuration: 0.1, animations: {
            self.tableViewBottomConstraint.constant = 0
        })
    }
    
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentSearchText(searchController.searchBar.text!)
        
        if searchBarIsEmpty() {
            filteredSongs = SongManager.shared().songs
            tableView.reloadData()
        }
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
