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
    //var dataStore = DBManager()
    
    
}

extension DiaryTVPresenter: DiaryTVProtocol {

    func goToSingleView(comment: String, address: String, dayLiteral: String, time: String, lat: Double, lon: Double, imageName: String) {
        router?.goToSingleView(comment: comment, address: address, dayLiteral: dayLiteral, time: time, lat: lat, lon: lon, imageName: imageName)
    }
    
    
}


//MARK: - Protocol -

protocol DiaryTVProtocol {
  func goToSingleView(comment: String, address: String, dayLiteral: String, time: String, lat: Double, lon: Double, imageName: String)
}

