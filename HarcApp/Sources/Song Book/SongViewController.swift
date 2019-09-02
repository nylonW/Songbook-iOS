//
//  SongViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 01/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

class SongViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var songText: UILabel!
    
    var song: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let song = song {
            name.text = song.title
            songText.text = song.songText.replacingOccurrences(of: " ", with: "\u{00a0}")
            
            let lines = song.songText.split(separator: "\n")
            for line in lines {
                var lineWidth = String(line.replacingOccurrences(of: " ", with: "_")).widthOfString(usingFont: songText.font)
                
                while lineWidth >= self.songText.frame.size.width {
                    self.songText.font = self.songText.font.withSize(songText.font.pointSize - 0.4)
                    lineWidth = String(line.replacingOccurrences(of: " ", with: "\u{00a0}")).widthOfString(usingFont: self.songText.font)
                    print(lineWidth)
                }
                
                self.songText.layoutIfNeeded()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
