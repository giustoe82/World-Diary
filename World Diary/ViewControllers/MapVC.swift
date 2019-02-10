//
//  MapVC.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-02.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {

    var presenter: MapProtocol?
    
    var locationManager = CLLocationManager()
    
    var thoroughfare: String?
    var subThoroughfare: String?
    var subAdministritiveArea: String?
    var address = String()
    var oneAddress = String()
    var lat: Double?
    var lon: Double?
    
    @IBOutlet weak var myMap: MKMapView!

}

extension MapVC: CLLocationManagerDelegate, MKMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        locationManager.requestLocation()
        //locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coord = manager.location?.coordinate {
            
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            myMap.setRegion(region, animated: true)
            myMap.removeAnnotations(myMap.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your location"
            myMap.addAnnotation(annotation)
            
            let userLocation =  CLLocation(latitude: center.latitude, longitude: center.longitude)
            
            CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
                
                if error != nil {
                    
                    print(error!)
                    
                } else {
                    
                    if let placemark = placemarks?[0] {
                        
                        var thoroughfare = ""
                        if placemark.thoroughfare != nil {
                            thoroughfare = placemark.thoroughfare!
                            self.address += thoroughfare + " "
                        }
                        
                        var subThoroughfare = ""
                        if placemark.subThoroughfare != nil {
                            subThoroughfare = placemark.subThoroughfare!
                            self.address += subThoroughfare + " "
                        }
                        
                        var subAdministritiveArea = ""
                        if placemark.subAdministrativeArea != nil {
                            subAdministritiveArea = placemark.subAdministrativeArea!
                            self.address += subAdministritiveArea + " "
                        }
                        
                        var country = ""
                        if placemark.country != nil {
                            country = placemark.country!
                            self.address += country
                        }
                        
                    }
                    
                }
                self.lat = coord.latitude
                self.lon = coord.longitude
                print(self.lat!)
                print(self.lon!)
                self.oneAddress = self.address
                self.address = ""
                //print(self.address)
                
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        manager.requestLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        print(oneAddress)
        address = ""
    }
}
