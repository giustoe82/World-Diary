//
//  Datastore.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-12.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit
import Firebase


struct Day {
    var opened = Bool()
    var date: String?
    var sectionData: [Entry]?
    var tableIndex = Int()
    
}

class Datastore {
    
    var dataBaseDelegate: DBProtocol? = DBManager()
    
    
    
    

    
    
    
    func getEntries() -> [Entry] {
        myArray = (dataBaseDelegate?.getEntries())!
        return myArray
    }
    
    func loadDB() {
        dataBaseDelegate?.loadDB()
    }
    

}


