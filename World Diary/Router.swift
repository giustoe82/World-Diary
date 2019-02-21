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
    
    //Diary TableView
    func presentDiaryTV() {
        if diaryController == nil {
            diaryController = storyBoard.instantiateViewController(withIdentifier: "diary") as? DiaryTV
            
            let presenter = DiaryTVPresenter()
            presenter.router = self
            diaryController!.presenter = presenter
        }
        rootController?.navigationController?.pushViewController(diaryController!, animated: true)
    }
    
    func goToDiary() {
//        if diaryController == nil {
//            diaryController = storyBoard.instantiateViewController(withIdentifier: "diary") as? DiaryTV
//
//            let presenter = DiaryTVPresenter()
//            presenter.router = self
//            diaryController!.presenter = presenter
//        }
        rootController?.navigationController?.popToRootViewController(animated: true)    }
    
    //Map
    func presentMapVC() {

        if mapController == nil {
            mapController = storyBoard.instantiateViewController(withIdentifier: "map") as? MapVC
            let presenter = MapPresenter()
            presenter.router = self
            mapController?.presenter = presenter
        }
        rootController?.navigationController?.pushViewController(mapController!, animated: true)
    }
    
    //SideMenu
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
        //Redirect to Home if user is logged
        if UserDefaults.standard.value(forKey: "uid") == nil {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            loginVC = storyBoard.instantiateViewController(withIdentifier: "loginVC") as? LoginVC
            
            rootController?.present(loginVC!, animated: true, completion: nil)
        }
    }
    
    //New Post Creation
    func goToNewPost() {
        let newPostVC = storyBoard.instantiateViewController(withIdentifier: "newPostVC") as? NewPostVC
        
        let presenter = NewPostPresenter()
        presenter.router = self
        newPostVC?.presenter = presenter
        
        rootController?.navigationController?.pushViewController(newPostVC!, animated: true)
    }
    
    //New Post Editing
    func toEdit(entry: Entry, index: Int) {
        let newPostVC = storyBoard.instantiateViewController(withIdentifier: "newPostVC") as? NewPostVC
        
        let presenter = NewPostPresenter()
        presenter.router = self
        newPostVC?.presenter = presenter
        newPostVC?.entryToEdit = entry
        newPostVC?.editOngoing = true
        newPostVC?.index = index
        
        rootController?.navigationController?.pushViewController(newPostVC!, animated: true)
    }
    
    //Detailed Post
    func goToSingleView(entry: Entry, index: Int) {
        let singleVC = storyBoard.instantiateViewController(withIdentifier: "singleEntryVC") as? ShowSingleEntryTV
        
        let presenter = SingleViewPresenter()
        presenter.router = self
        singleVC?.presenter = presenter
        singleVC?.entry = entry
        singleVC?.index = index

        rootController?.navigationController?.pushViewController(singleVC!, animated: true)
    }
    
    //Photo CollectionView
    func goToCollection() {
        let collectionVC = storyBoard.instantiateViewController(withIdentifier: "collection") as? CollectionGalleryVC
        
        let presenter = CollectionPresenter()
        presenter.router = self
        collectionVC?.presenter = presenter
        
        rootController?.navigationController?.pushViewController(collectionVC!, animated: true)
    }
    
    func goToFullScreen(image: String) {
        let fullScreenVC = storyBoard.instantiateViewController(withIdentifier: "fullScreenVC") as? FullScreenPicVC
        fullScreenVC?.loadImage(imgUrl: image)
        rootController?.navigationController?.pushViewController(fullScreenVC!, animated: true)
    }
    
    //AI
    func goToAdvancedCamera(){
        let cameraVC = storyBoard.instantiateViewController(withIdentifier: "cameraVC") as? CameraVC
        
        let presenter = AdvancedCameraPresenter()
        presenter.router = self
        cameraVC?.presenter = presenter
        
        rootController?.navigationController?.pushViewController(cameraVC!, animated: true)
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
