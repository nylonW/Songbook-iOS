//
//  PopupViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 09/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var largeSunImage: UIImageView!
    @IBOutlet weak var smallSunImage: UIImageView!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var ytButton: UIButton!
    
    var isDarkMode = false
    var song: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isDarkMode = UserDefaults.standard.bool(forKey: "darkMode")
        
        if isDarkMode {
            view.backgroundColor = Constants.Colors.darkSecondary
            largeSunImage.image = largeSunImage.image?.withRenderingMode(.alwaysTemplate)
            largeSunImage.tintColor = .white
            smallSunImage.image = smallSunImage.image?.withRenderingMode(.alwaysTemplate)
            smallSunImage.tintColor = .white
        }
        ytButton.imageView?.contentMode = .scaleAspectFit
        
        brightnessSlider.value = Float(UIScreen.main.brightness)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        UIScreen.main.brightness = CGFloat(sender.value)
    }
    
    @IBAction func copyTapped(_ sender: UIButton) {
        if let song = song {
            UIPasteboard.general.string = song.songText
            sender.setTitle("Skopiowano!", for: .normal)
        }
    }
    
    @IBAction func ytTapped(_ sender: UIButton) {
        if let song = song {
            let youtubeId = song.link?.split(separator: "=")[1]
            let deeplink = "youtube://\(youtubeId ?? "")"
            let url = URL(string: song.link ?? "https://www.youtube.com")!
            
            if let youtubeUrl = URL(string: deeplink), UIApplication.shared.canOpenURL(youtubeUrl) {
                UIApplication.shared.open(youtubeUrl, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
