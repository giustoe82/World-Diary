//
//  LeftMenuPresenter.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-08.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit

class LeftMenuPresenter {
    
    weak var router: Router?
    
}

extension LeftMenuPresenter: LeftMenuPresenterProtocol {
    func logOut() {
        router?.logOut()
        
    }
}

//MARK: - Protocol -

protocol LeftMenuPresenterProtocol {
    
    func logOut()
    
}
