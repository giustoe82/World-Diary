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
    
}


//MARK: - Protocol -

protocol PresenterToViewProtocol {
    
    func openLeftMenu()
    func toDiaryTV()
    func toMapVC()
    func goToLogin()
    func goToNewPost()
    func goToCollection()
}
