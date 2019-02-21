//
//  Artwork.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-21.
//  Copyright © 2019 marcog. All rights reserved.
//

import Foundation
import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let comment: String
    //let picture: UIImage?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, comment: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.comment = comment
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
