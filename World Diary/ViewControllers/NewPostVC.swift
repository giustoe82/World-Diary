//
//  newPostVC.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-09.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation



class NewPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let dataManager = DBManager()
    var presenter: newPostPresenterProtocol?
    var locationManager = CLLocationManager()
    var imagePicker = UIImagePickerController()
   //var frameExtractor: CameraVC?
    
    //variables and outlets to be stored
    var lat: Double?
    var lon: Double?
    var images: [UIImage]?
    var dayOfPost: String?
    let uid = Auth.auth().currentUser?.uid
    var address = String()
    var oneAddress = String()
    var myLat: Double?
    var myLon: Double?
    var dayName: String?
    
    @IBOutlet weak var noteTextView: UITextField!
    @IBOutlet weak var imgToSave: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    //@IBOutlet weak var openAdvancedCameraButton: UIButton!
    
    var imageToShare: UIImage?
    var editOngoing: Bool = false
    var entryToEdit: Entry?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.EntriesArray.removeAll()
        dataManager.loadDataBase()
        
//        frameExtractor = CameraVC()
//        frameExtractor?.delegate = self as? FrameExtractorDelegate
        locationManager.delegate = self
        imagePicker.delegate = self
        noteTextView.delegate = self
        self.navigationItem.title = getCurrentDate()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if editOngoing, let myEntry = entryToEdit {
            noteTextView.text = myEntry.comment
            if let imgUrl = entryToEdit?.imgUrl {
                loadImage(imgUrl: imgUrl)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if noteTextView.text == "" {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.lightGray
        }
    }
    
//    @IBAction func openAdvancedCameraAction(_ sender: Any) {
//        presenter?.goToAdvancedCamera()
//    }
//
//    func captured(image: UIImage) {
//        imgToSave.image = image
//    }
    

    @IBAction func saveAction(_ sender: Any) {
        if editOngoing == false {
            saveToDB()
            noteTextView.text = ""
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.lightGray
        } else if editOngoing, entryToEdit != nil {
            editToDB()
            noteTextView.text = ""
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.lightGray
        }
    }
    
    func saveToDB() {
        dataManager.singleEntry.comment = noteTextView.text ?? ""
        dataManager.singleEntry.date = getCurrentDate()
        dataManager.singleEntry.time = getCurrentTime()
        dataManager.singleEntry.address = oneAddress
        dataManager.singleEntry.lat = lat ?? 0.0
        dataManager.singleEntry.lon = lon ?? 0.0
        dataManager.singleEntry.timeStamp = Timestamp()
        dataManager.singleEntry.uID = uid!
        dataManager.singleEntry.dayLiteral = getCurrentDay()
        
        if imgToSave.image != nil {
            dataManager.singleEntry.img = imgToSave.image
        }
        dataManager.uploadData()
    }
    
    func editToDB() {
        if let myIndex = index {
            deleteBeforeEdit(index: myIndex)
        
        dataManager.singleEntry.comment = noteTextView.text! + "\n(edited)"
        dataManager.singleEntry.date = (entryToEdit?.date)!
        dataManager.singleEntry.time = (entryToEdit?.time)!
        dataManager.singleEntry.address = (entryToEdit?.address)!
        dataManager.singleEntry.lat = entryToEdit?.lat ?? 0.0
        dataManager.singleEntry.lon = entryToEdit?.lon ?? 0.0
        dataManager.singleEntry.timeStamp = entryToEdit?.timeStamp
        dataManager.singleEntry.uID = uid!
        dataManager.singleEntry.dayLiteral = (entryToEdit?.dayLiteral)!
        
        if imgToSave.image != nil {
            dataManager.singleEntry.img = imgToSave.image
        }
        dataManager.uploadData()
            
        }
    }
    
    func deleteBeforeEdit(index: Int) {
        dataManager.deleteImage(position: index)
        dataManager.deleteThumb(position: index)
        dataManager.deleteFromDB(position: index)
        dataManager.EntriesArray.remove(at: index)
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
                        
                        self.imgToSave.image = myImg
                        
                    }
                }
            }
        }
    }
    

 //: - MARK: - Keyboard related
  
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = true
        saveButton.backgroundColor = UIColor.blue
    }
        
//        func textFieldDidBeginEditing(_ noteTextView: UITextField) {
//            saveButton.isEnabled = true
//            saveButton.backgroundColor = UIColor.blue
//        }
    
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            self.view.endEditing(true)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            textField.resignFirstResponder()
            
            return true
        }
    
    
 
//: - MARK: - Fetch Time and Day
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let str = formatter.string(from: Date())
        return str
    }
    
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let str = formatter.string(from: Date())
        return str
    }
    
    func getCurrentDay() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "LLLL"
        let month = dateFormatter.string(from: date)
        let dayMonth = Calendar.current.ordinality(of: .day, in: .month, for: date)
        var myString = ""
        if let myDay = dayMonth {
            myString = String(myDay)
        }
        let today = month + " " + myString + " " + dayInWeek
        return today
    }

//: - MARK: - Taking Pictures

    @IBAction func takePicture(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imgToSave.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageToShare = shareableImage(image: (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!)
        dismiss(animated: true, completion: nil)
    }
    
    func shareableImage(image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        let size: CGSize = CGSize(width: CGFloat(cgImage.width) / image.scale, height: CGFloat(cgImage.height) / image.scale)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        
        image.draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? image
    }

}

//: - MARK: - Fetch Location

extension NewPostVC: CLLocationManagerDelegate {
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        print(oneAddress)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
       if let coord = manager.location?.coordinate {

            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
        
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
                self.lat = locations[0].coordinate.latitude
                self.myLat = self.lat
                self.lon = locations[0].coordinate.longitude
                self.myLon = self.lon
                self.oneAddress = self.address
                self.address = ""
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        manager.requestLocation()
    }

}
