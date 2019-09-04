//
//  UIColor+SystemColors.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 04/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

extension UIColor {
    static var systemBlue: UIColor {
        return UIButton(type: .system).tintColor
    }
}
