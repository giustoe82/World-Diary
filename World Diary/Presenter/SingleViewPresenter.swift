//
//  SingleViewPresenter.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-20.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit

class SingleViewPresenter {
    
    weak var router: Router?
    
}

extension SingleViewPresenter: SingleViewPresenterProtocol {
    
    func toEdit(entry: Entry, index: Int) {
        router?.toEdit(entry: entry, index: index)
    }
    
}

//MARK: - Protocol -

protocol SingleViewPresenterProtocol {
    func toEdit(entry: Entry, index: Int)
    
}
