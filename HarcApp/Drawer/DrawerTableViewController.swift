//
//  DrawerTableViewController.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 02/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

class DrawerTableViewController: UITableViewController {
    
    @IBOutlet weak var songBookCell: UITableViewCell!
    @IBOutlet weak var aboutCell: UITableViewCell!
    
    var delegate: ManageDrawerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(closeDrawer)))
        
    }
    
    @objc func closeDrawer(gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: self.view)
        
        if velocity.x > 0 {
            //paning right
        } else if velocity.x < -500 {
            delegate?.closeDrawer()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red:0.03, green:0.50, blue:0.14, alpha:1.0)
        cell?.selectedBackgroundView = bgColorView
        
        delegate?.select(at: indexPath.row)
        if indexPath.row != 0 {
            delegate?.closeDrawer()
        } else if indexPath.row == 0 {
            cell?.setSelected(false, animated: false)
        }
    }
}
