//
//  DiaryTVPresenter.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-01-31.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit

class DiaryTVPresenter {
    
    weak var router: Router?
    
}

extension DiaryTVPresenter: DiaryTVProtocol {

    func goToSingleView(entry: Entry, index: Int) {
        router?.goToSingleView(entry: entry, index: index)
    }
    
}


//MARK: - Protocol -

protocol DiaryTVProtocol {
    func goToSingleView(entry: Entry, index: Int)
}

