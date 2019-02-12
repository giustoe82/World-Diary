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

//    func getAllPosts() -> [Day] {
//        return prepareArray()
//    }
    func prepareArray() -> [Day] {
        return (router?.fillWith(myArray: (router?.getEntries())!))!
    }
    
    
}


//MARK: - Protocol -

protocol DiaryTVProtocol {
    
    //func getAllPosts() -> [Day]
    func prepareArray() -> [Day]
}

