//
//  ShowSingleEntryTV.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-15.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ShowSingleEntryTV: UITableViewController, MKMapViewDelegate {
    
    
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var imageField: UIImageView!
    
    var getComment = String()
    var getAddress = String()
    var getDate = String()
    var getTime = String()
    var getLat = Double()
    var getLon = Double()
    var getImageName = String()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Details"
        dateTimeLabel.text = getDate + " at " + getTime
        commentLabel.text = getComment
        addressLabel.text = getAddress
        loadImage(imgUrl: getImageName)
        print(getLat)
        
        
        
        
        let center = CLLocationCoordinate2D(latitude: getLat, longitude: getLon)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Entry taken here"
        map.addAnnotation(annotation)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if cell.tag == 1 { return 40 }
        if cell.tag == 3 && getLat == 0 && getLon == 0 {
            return 0
        } else if cell.tag == 3 && getLat != 0 && getLon != 0{
            return 300
        }
        if cell.tag == 4 && getAddress == "" {
            return 0
        } else if cell.tag == 4 && getAddress != ""{
            return 30
        }
        if cell.tag == 5 && getImageName == "" {
            return 0
        } else if cell.tag == 5 && getImageName != ""{
            return 300
        }
        return 20
    }
    
    
    
    
    func loadImage(imgUrl:String)  {
        
        let storageRef = Storage.storage().reference()
        let imgRef = storageRef.child(imgUrl)
        imgRef.getData(maxSize: 1024*1024) { data, error in
            if let error = error {
                print(error)
            } else {
                if let imgData = data {
                    
                    if let myImg = UIImage(data: imgData) {
                        
                        self.imageField.image = myImg
                        
                    }
                }
            }
        }
    }
    
}
