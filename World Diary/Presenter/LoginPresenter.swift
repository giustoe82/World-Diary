//
//  LoginPresenter.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-22.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit

class LoginPresenter {
    
    weak var router: Router?
    
}

extension LoginPresenter: LoginProtocol {
    
    func goToHome() {
        router?.goToHome()
    }
    
}

//MARK: - Protocol -

protocol LoginProtocol {
    func goToHome()
    
}
