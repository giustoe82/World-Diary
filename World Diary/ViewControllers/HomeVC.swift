//
//  ViewController.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-01-30.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit
import SideMenu

class HomeVC: UIViewController {

    var presenter: PresenterToViewProtocol?
    
    @IBOutlet weak var leftMenuBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // (Optional) Prevent status bar area from turning black when menu appears:
        //SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = 0.7
        SideMenuManager.default.menuAnimationTransformScaleFactor = 0.9
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.goToLogin()
    }
    

    @IBAction func openLeftMenuButton(_ sender: Any) {
        presenter?.openLeftMenu()
    }
    @IBAction func toDiaryButton(_ sender: Any) {
        presenter?.toDiaryTV()
    }
    
    @IBAction func toMapButton(_ sender: Any) {
        presenter?.toMapVC()
    }
    @IBAction func goToNewPost(_ sender: Any) {
        presenter?.goToNewPost()
    }
    @IBAction func toCollection(_ sender: Any) {
        presenter?.goToCollection()
    }
}

