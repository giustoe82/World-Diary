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
    var dataManager = DBManager()
    
    var thoroughfare: String?
    var subThoroughfare: String?
    var subAdministritiveArea: String?
    var address = String()
    var oneAddress = String()
    var lat: Double?
    var lon: Double?
    var isLoaded: Bool = false
    var artworks: [Artwork] = [] { didSet{
        myMap.addAnnotations(artworks)
        }}
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    
}

extension MapVC: CLLocationManagerDelegate, MKMapViewDelegate, DataDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.dataDel = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()
        animateLoadingView()
        
        
        let artwork = Artwork(title: "King David Kalakaua",
                              locationName: "Waikiki Gateway Park",
                              comment: "Sculpture",
                              coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        myMap.addAnnotation(artwork)
        
    }
    
    
    
    func reload() {
        for entry in dataManager.EntriesArray {
            let artwork = Artwork(title: entry.dayLiteral,
                                  locationName: entry.address ?? "",
                                  comment: entry.comment,
                                  coordinate: CLLocationCoordinate2D(latitude: entry.lat!, longitude: entry.lon!))
            artworks.append(artwork)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myMap.register(ArtworkView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        dataManager.loadDataBase()
        locationManager.requestLocation()
        //locationManager.stopUpdatingLocation()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        print(oneAddress)
        address = ""
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            myMap.setRegion(region, animated: true)
//            myMap.removeAnnotations(myMap.annotations)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = center
//            annotation.title = "Your location"
//            myMap.addAnnotation(annotation)
            if loadingView != nil {
                loadingView.removeFromSuperview()
                isLoaded = true
            }
            
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
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        manager.requestLocation()
    }
    
    func animateLoadingView() {
        UIView.animate(withDuration: 2, delay: 0, options:
                    [.repeat, .autoreverse], animations: {
                        self.loadingView.alpha = 0.3
        })
    }
    
}

extension MapVC {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Artwork else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}


