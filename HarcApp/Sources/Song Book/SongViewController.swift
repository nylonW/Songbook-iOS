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
    @IBOutlet weak var chords: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var performer: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var song: Song?
    var isFavourite = false
    var favouriteSongs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favouriteSongs = UserDefaults.standard.stringArray(forKey: "favouriteSongs") ?? []

        if let song = song {
            name.text = song.title
            songText.text = song.songText
            chords.text = song.songChords
            author.text = "Autor słów: \(song.author ?? "-")"
            performer.text = "Wykonawca: \(song.performer ?? "-")"
            chords.lineSpacing(spacing: 1)
            songText.lineSpacing(spacing: 1)
            
            var lines = song.songText.split(separator: "\n").map(String.init)
            var largestLine = lines[0]
            for line in lines {
                if String(line).widthOfString(usingFont: songText.font) > String(largestLine).widthOfString(usingFont: songText.font) {
                    largestLine = line
                }
            }
            
            var fontSize: CGFloat = songText.font.pointSize
            var lineWidth = String(largestLine).widthOfString(usingFont: songText.font)
            
            songText.layoutIfNeeded()
            
            while lineWidth > self.songText.frame.size.width {
                fontSize -= 0.6
                    
                self.songText.font = self.songText.font.withSize(fontSize)
                self.chords.font = self.songText.font.withSize(fontSize)
                self.songText.setNeedsLayout()
                self.songText.layoutIfNeeded()
                
                lineWidth = String(largestLine).widthOfString(usingFont: self.songText.font.withSize(fontSize))
            }
            
            if favouriteSongs.contains(song.fileName) {
                isFavourite = true
                favouriteButton.setImage(#imageLiteral(resourceName: "icons8-heart-50-filled.png"), for: .normal)
            }
        }
    }
    
    @IBAction func favouriteButtonTapped(_ sender: Any) {
        isFavourite.toggle()
        favouriteSongs = UserDefaults.standard.stringArray(forKey: "favouriteSongs") ?? []
        guard let songName = song?.fileName else { return }
        
        if isFavourite {
            favouriteSongs.append(songName)
            favouriteButton.setImage(#imageLiteral(resourceName: "icons8-heart-50-filled.png"), for: .normal)
        } else {
            favouriteSongs.removeAll(where: {$0 == songName})
            favouriteButton.setImage(#imageLiteral(resourceName: "icons8-heart-50.png"), for: .normal)
        }
        
        UserDefaults.standard.set(favouriteSongs, forKey: "favouriteSongs")
        print(favouriteSongs)
    }
}

extension UILabel {
    func lineSpacing(spacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = spacing // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        self.attributedText = attributedString
    }
}
