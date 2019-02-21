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
    
    var presenter: SingleViewPresenterProtocol?
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var imageField: UIImageView!
    
    var getComment: String?
    var getAddress: String?
    var getDate: String?
    var getTime: String?
    var getLat: Double?
    var getLon: Double?
    var getImageName: String?
    var entry: Entry?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupMapView()
        
    }
    
    @IBAction func toEditViewAction(_ sender: Any) {
        if entry != nil {
            presenter?.toEdit(entry: entry!, index: index!)
            dateTimeLabel.text = ""
            commentLabel.text = ""
            addressLabel.text = ""
            imageField.image = nil
            //self.popViewController(animated: true)
        }
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
        } else if cell.tag == 6 {
            return 50
        }
        return 20
    }
    
    func setup() {
        let singleTitle = NSLocalizedString("singleViewTitle", comment: "")
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = singleTitle
        getComment = entry?.comment
        getAddress = entry?.address
        getDate = entry?.date
        getTime = entry?.time
        getLat = entry?.lat
        getLon = entry?.lon
        getImageName = entry?.imgUrl
        dateTimeLabel.text = getDate! + " at " + getTime!
        commentLabel.text = getComment
        addressLabel.text = getAddress
        loadImage(imgUrl: getImageName!)
    }
    
    func setupMapView() {
        let center = CLLocationCoordinate2D(latitude: getLat!, longitude: getLon!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        map.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Entry taken here"
        map.addAnnotation(annotation)
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
