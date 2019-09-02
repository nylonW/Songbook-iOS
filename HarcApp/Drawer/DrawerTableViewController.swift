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
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.select(at: indexPath.row)
        if indexPath.row != 0 {
            delegate?.closeDrawer()
        } else if indexPath.row == 0 {
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
        }
    }
}
