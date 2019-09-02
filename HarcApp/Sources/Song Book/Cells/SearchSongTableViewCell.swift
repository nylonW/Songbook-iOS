//
//  SearchSongTableViewCell.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 02/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

class SearchSongTableViewCell: UITableViewCell {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var tags: UILabel!
    
    var song: Song? {
        didSet {
            songName.text = song?.title
            if let author = song?.author {
                self.author.text = author
            } else {
                author.text = "-"
            }
            tags.text = song?.tagsAsString
            if song?.tagsAsString.count ?? 0 <= 1 {
                tags.text = ""
            }
        }
    }
}
