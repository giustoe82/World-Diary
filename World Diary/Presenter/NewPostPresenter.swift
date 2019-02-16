//
//  newPostPresenter.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-09.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit

class NewPostPresenter {
    
    weak var router: Router?
    //weak var dataStore: Datastore?
}

extension NewPostPresenter: newPostPresenterProtocol {
    
    func uploadData() {
        //dataStore?.dataBaseDelegate?.uploadData()
    }
    func goToCamera(){
        router?.goToCamera()

    }
    
}


//MARK: - Protocol -

protocol newPostPresenterProtocol {

    func uploadData()
    func goToCamera()
    
}
