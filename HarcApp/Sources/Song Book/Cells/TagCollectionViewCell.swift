//
//  TagCollectionViewCell.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 12/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        container.layer.cornerRadius = contentView.frame.size.height / 2
        container.layer.borderColor = UIColor.black.cgColor
        container.layer.borderWidth = 1
    }
}
