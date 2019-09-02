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
    
    var song: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let song = song {
            name.text = song.title
            songText.text = song.songText.replacingOccurrences(of: " ", with: "\u{00a0}")
            chords.text = song.songChords.replacingOccurrences(of: " ", with: "\u{00a0}")
            chords.lineSpacing(spacing: 1)
            songText.lineSpacing(spacing: 1)
            
            let lines = song.songText.split(separator: "\n")
            for line in lines {
                var lineWidth = String(line.replacingOccurrences(of: " ", with: "_")).widthOfString(usingFont: songText.font)
                
                while lineWidth >= self.songText.frame.size.width {
                    let fontSize = songText.font.pointSize - 0.1
                    self.songText.font = self.songText.font.withSize(fontSize)
                    self.chords.font = self.songText.font.withSize(fontSize)
                    
                    lineWidth = String(line.replacingOccurrences(of: " ", with: "_")).widthOfString(usingFont: self.songText.font)
                    //print(lineWidth)
                    
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
