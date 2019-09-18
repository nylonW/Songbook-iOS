//
//  SongViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 01/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

protocol PresentSearchControllerDelegate {
    func presentSearchController(withText: String)
}

class SongViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var songText: UILabel!
    @IBOutlet weak var chords: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var performer: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var favouriteButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var constraint: NSLayoutConstraint?
    var song: Song?
    var isFavourite = false
    var favouriteSongs: [String] = []
    var fromFavourites = false
    var isDarkMode = false
    var showChords = true
    
    var scalledFont: CGFloat?
    var scalledChordsTextLabelWidth: CGFloat?
    
    let safeSpacing: CGFloat = 2
    let fontStep: CGFloat = 0.6
    let tagCellId = "TagCollectionViewCell"
    var delegate: PresentSearchControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favouriteSongs = UserDefaults.standard.stringArray(forKey: "favouriteSongs") ?? []
        isDarkMode = UserDefaults.standard.bool(forKey: "darkMode")
        showChords = UserDefaults.standard.bool(forKey: "showChords")
        
        if fromFavourites {
            favouriteButton.isHidden = true
            favouriteButtonWidth.constant = 0
            favouriteButton.layoutIfNeeded()
            collectionView.isHidden = true
        }

        if let song = song {
            name.text = song.title
            songText.text = song.songText
            chords.text = song.songChords
            author.text = "\(NSLocalizedString("song_author", comment: "")): \(song.author ?? "-")"
            performer.text = "\(NSLocalizedString("song_performer", comment: "")): \(song.performer ?? "-")"
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
            
            while lineWidth + safeSpacing >= songText.frame.size.width {
                fontSize -= fontStep
                    
                songText.font = songText.font.withSize(fontSize)
                chords.font = songText.font.withSize(fontSize)
                songText.setNeedsLayout()
                songText.layoutIfNeeded()
                
                lineWidth = String(largestLine).widthOfString(usingFont: self.songText.font.withSize(fontSize))
            }
            
            scalledFont = fontSize
            scalledChordsTextLabelWidth = songText.frame.width
            constraint = NSLayoutConstraint(item: chords!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
            
            if favouriteSongs.contains(song.fileName) {
                isFavourite = true
                favouriteButton.setImage(#imageLiteral(resourceName: "icons8-heart-50-filled.png").withRenderingMode(.alwaysTemplate), for: .normal)
            } else {
                favouriteButton.setImage(#imageLiteral(resourceName: "icons8-heart-50.png").withRenderingMode(.alwaysTemplate), for: .normal)
            }
        }
        
        setupCollectionView()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDarkMode()
        setShowChords()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: tagCellId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: tagCellId)
        
    }

    func setShowChords() {
        showChords = UserDefaults.standard.bool(forKey: "showChords")
        guard let constraint = constraint else { return }
        
        if showChords {
            chords.isHidden = false
            NSLayoutConstraint.deactivate([constraint])
            chords.layoutIfNeeded()
            songText.font = songText.font.withSize(scalledFont ?? 17)
        } else {
            chords.isHidden = true
            NSLayoutConstraint.activate([constraint])
            songText.font = songText.font.withSize(17)
        }
    }
    
    func setDarkMode() {
        isDarkMode = UserDefaults.standard.bool(forKey: "darkMode")
        
        if isDarkMode {
            self.view.backgroundColor = .black
            name.textColor = .white
            songText.textColor = .white
            chords.textColor = .white
            author.textColor = .white
            performer.textColor = .white
            favouriteButton.tintColor = .white
        } else {
            self.view.backgroundColor = .white
            name.textColor = .black
            songText.textColor = .black
            chords.textColor = .black
            author.textColor = .black
            performer.textColor = .black
            favouriteButton.tintColor = .black
        }
    }
    
    @IBAction func favouriteButtonTapped(_ sender: Any) {
        isFavourite.toggle()
        favouriteSongs = UserDefaults.standard.stringArray(forKey: "favouriteSongs") ?? []
        guard let songName = song?.fileName else { return }
        
        if isFavourite {
            favouriteSongs.append(songName)
            favouriteButton.setImage(#imageLiteral(resourceName: "icons8-heart-50-filled.png").withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            favouriteSongs.removeAll(where: {$0 == songName})
            favouriteButton.setImage(#imageLiteral(resourceName: "icons8-heart-50.png").withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        UserDefaults.standard.set(favouriteSongs, forKey: "favouriteSongs")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return song?.tags.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellId, for: indexPath) as! TagCollectionViewCell
        
        cell.tagLabel.text = song?.tags[indexPath.item] ?? ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let song = song else { return .zero }
        
        let width = song.tags[indexPath.item].widthOfString(usingFont: Constants.fonts.museo?.withSize(16) ?? UIFont())
        
        return CGSize(width: width + 17, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.presentSearchController(withText: song?.tags[indexPath.item] ?? "")
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
