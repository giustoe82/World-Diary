//
//  LeftMenuVC.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-08.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit

class LeftMenuVC: UITableViewController {
    
    var presenter: LeftMenuPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            presenter?.logOut()
        case 1:
            print("0")
        case 2:
            print("0")
        default:
            break
        }
    }
    
}
