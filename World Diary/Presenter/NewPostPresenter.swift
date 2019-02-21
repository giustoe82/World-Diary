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
    
}

extension NewPostPresenter: newPostPresenterProtocol {
    
    func redirect() {
        router?.goToDiary()
    }
    
}


//MARK: - Protocol -

protocol newPostPresenterProtocol {
    func redirect()
}
