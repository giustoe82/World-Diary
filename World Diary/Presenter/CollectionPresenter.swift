//
//  CollectionPresenter.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-10.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit

class CollectionPresenter {
    
    weak var router: Router?
    //weak var dataStore: Datastore?
}

extension CollectionPresenter: CollectionPresenterProtocol {
    func showFullImage() {
        
    }
    
    
}


//MARK: - Protocol -

protocol CollectionPresenterProtocol {
    
    func showFullImage()
    
}

