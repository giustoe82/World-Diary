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

//temp API
struct Day {
    var opened = Bool()
    var date: String?
    var sectionData: [Entry]?
    var tableIndex = Int()
    
}

struct Entry {
    
    var dayTime: String?
    var address: String?
    var myText: String?
    var thumbName: String?
    var dayLiteral: String?
}

class Router {
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var rootController: HomeVC?
    var leftMenuVC: LeftMenuVC?
    var loginVC: LoginVC?
    var mapController: MapVC?
    var diaryController: DiaryTV?
    
    var myArray: [Entry] = []
    var days: [Day] = []
    var newDay: Day?
    
    let entry00 =  Entry(dayTime: "17:55", address: "Sergel Torg", myText: "Snowy day" , thumbName: "tempSnow", dayLiteral: "February 1 Friday")
    let entry01 =  Entry(dayTime: "17:56", address: "Sergel Torg", myText: "Snowy day" , thumbName: "tempSnow", dayLiteral: "February 2 Friday")
    let entry02 =  Entry(dayTime: "17:57", address: "Sergel Torg", myText: "Snowy day" , thumbName: "tempSnow", dayLiteral: "February 2 Friday")
    let entry03 =  Entry(dayTime: "17:58", address: "Sergel Torg", myText: "Snowy day" , thumbName: "tempSnow", dayLiteral: "February 3 Friday")
    let entry04 =  Entry(dayTime: "17:59", address: "Sergel Torg", myText: "Snowy day" , thumbName: "tempSnow", dayLiteral: "February 3 Friday")
    let entry05 =  Entry(dayTime: "18:02", address: "Sergel Torg", myText: "Snowy day" , thumbName: "tempSnow", dayLiteral: "February 3 Friday")
    
    func fillWith(myArray:[Entry]) -> [Day]{
        
        days.removeAll()
        let newArray = myArray.reversed()
        var counter: Int = 0
        
        for entry in newArray {
            if newDay != nil {
                if entry.dayLiteral == newDay?.date {
                    newDay?.sectionData?.append(entry)
                } else {
                    days.append(newDay!)
                    counter += 1
                    newDay = Day(opened: false, date: entry.dayLiteral, sectionData: [], tableIndex: counter)
                    newDay?.sectionData?.append(entry)
                }
            } else {
                newDay = Day(opened: false, date: entry.dayLiteral, sectionData: [], tableIndex: counter)
                newDay?.sectionData?.append(entry)
                counter += 1
            }

        }
        days.append(newDay!)
        newDay = nil
        print (days)
        return days
    }
    
    
    
    func getEntries() -> [Entry] {
        myArray.removeAll()
        
        myArray.append(entry00)
        myArray.append(entry01)
        myArray.append(entry02)
        myArray.append(entry03)
        myArray.append(entry04)
        myArray.append(entry05)
        
        return myArray
    }
    

    
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
    
    func goToCollection() {
        let collectionVC = storyBoard.instantiateViewController(withIdentifier: "collection") as? CollectionVC
        
        let presenter = CollectionPresenter()
        presenter.router = self
        collectionVC?.presenter = presenter
        
        rootController?.navigationController?.pushViewController(collectionVC!, animated: true)
    }
    
    //: - MARK: - Data transfer
    
    func getAllPosts() -> [Entry] {
        return myArray
    
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
