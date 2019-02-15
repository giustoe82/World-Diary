//
//  Router.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-01-31.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit
import SideMenu
import Firebase




class Router {
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var rootController: HomeVC?
    var leftMenuVC: LeftMenuVC?
    var loginVC: LoginVC?
    var mapController: MapVC?
    var diaryController: DiaryTV?
    
    
    
    
    
//: - MARK: - Navigation
    
    func presentDiaryTV() {
        if diaryController == nil {
            diaryController = storyBoard.instantiateViewController(withIdentifier: "diary") as? DiaryTV
            
            let presenter = DiaryTVPresenter()
            presenter.router = self
            diaryController!.presenter = presenter
        }
        rootController?.navigationController?.pushViewController(diaryController!, animated: true)
    }
    
    func presentMapVC() {

        if mapController == nil {
            mapController = storyBoard.instantiateViewController(withIdentifier: "map") as? MapVC
            let presenter = MapPresenter()
            presenter.router = self
            mapController?.presenter = presenter
        }
        rootController?.navigationController?.pushViewController(mapController!, animated: true)
    }
    
    func openLeftMenu() {
        
        if leftMenuVC == nil {
           leftMenuVC = storyBoard.instantiateViewController(withIdentifier: "leftMenu") as? LeftMenuVC
            
            let leftMenuPresenter = LeftMenuPresenter()
            leftMenuPresenter.router = self
            leftMenuVC?.presenter = leftMenuPresenter
        }
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: leftMenuVC!)
        
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        rootController?.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        
    }
    
    func goToLogin() {
        if UserDefaults.standard.value(forKey: "uid") == nil {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            loginVC = storyBoard.instantiateViewController(withIdentifier: "loginVC") as? LoginVC
            
            rootController?.present(loginVC!, animated: true, completion: nil)
        }
        
    }
    
    func goToNewPost() {
        let newPostVC = storyBoard.instantiateViewController(withIdentifier: "newPostVC") as? NewPostVC
        
        let presenter = NewPostPresenter()
        presenter.router = self
        newPostVC?.presenter = presenter
        
        rootController?.navigationController?.pushViewController(newPostVC!, animated: true)
    }
    
    func goToSingleView(comment: String, address: String, dayLiteral: String, time: String, lat: Double, lon: Double, imageName: String) {
        let singleVC = storyBoard.instantiateViewController(withIdentifier: "singleEntryVC") as? ShowSingleEntryTV
       
        singleVC?.getComment = comment
        singleVC?.getAddress = address
        singleVC?.getDate = dayLiteral
        singleVC?.getTime = time
        singleVC?.getLat = lat
        singleVC?.getLon = lon
        singleVC?.getImageName = imageName
        rootController?.navigationController?.pushViewController(singleVC!, animated: true)
    }
    
    func goToCollection() {
        let collectionVC = storyBoard.instantiateViewController(withIdentifier: "collection") as? CollectionVC
        
        let presenter = CollectionPresenter()
        presenter.router = self
        collectionVC?.presenter = presenter
        
        rootController?.navigationController?.pushViewController(collectionVC!, animated: true)
    }
    
  
 
    
    
    func logOut(){
        try? Auth.auth().signOut()
        UserDefaults.standard.removeObject(forKey: "uid")
        SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true)
        if loginVC == nil {
            loginVC = storyBoard.instantiateViewController(withIdentifier: "loginVC") as? LoginVC
            rootController?.present(loginVC!, animated: true, completion: nil)
        } else {
            rootController?.present(loginVC!, animated: true, completion: nil)
        }
    }
    
    
}
