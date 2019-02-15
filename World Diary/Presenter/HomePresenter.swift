//
//  FirstPagePresenter.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-01-31.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit

class HomePresenter {
    
    weak var router: Router?
    var dataStore = DBManager()
    var entries: [Entry] = []
    
//    let handlerBlock: (Bool) -> Void = { isLoaded in
//        if isLoaded {
//
//        }
//    }
//
//    func workHard(enterDoStuff: (Bool) -> Void) {
//        // Replicate Downloading/Uploading
//        for _ in 1...1000 {
//            print("👷🏻‍👷🏻👷🏽👷🏽️👷🏿‍️👷🏿")
//        }
//        enterDoStuff(true)
//    }
//

    
}

extension HomePresenter: PresenterToViewProtocol {
    
    func goToCollection() {
        router?.goToCollection()
    }
    
    
    func openLeftMenu() {
        router?.openLeftMenu()
    }
    
    func toDiaryTV() {
        router?.presentDiaryTV()
        //prepareArray()
    }
    
    func toMapVC() {
        router?.presentMapVC()
    }
    
    func goToLogin() {
        router?.goToLogin()
    }
    
    func goToNewPost() {
        router?.goToNewPost()
    }
    
//    func loadDB() {
//        dataStore.loadDB()
//        print(dataStore.EntriesArray)
//    }
    
    func loadDB() {

        dataStore.loadDB()
        
    }
    
   
}

//MARK: - Protocol -

protocol PresenterToViewProtocol {
    
    func openLeftMenu()
    func toDiaryTV()
    func toMapVC()
    func goToLogin()
    func goToNewPost()
    func goToCollection()
    func loadDB()
    
}
