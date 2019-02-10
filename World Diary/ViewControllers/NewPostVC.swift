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

class NewPostVC: UIViewController {
    
    var presenter: newPostPresenterProtocol?

    //connection to DB class
    //let dataManager = DBManager()
    
    let imagePicker = UIImagePickerController()
    
    //variables and outlets to be stored
    var address: String?
    var lat: Double?
    var lon: Double?
    var images: [UIImage]?
    var dayOfPost: String?
    let uid = Auth.auth().currentUser?.uid
    
    
    @IBOutlet weak var noteTextView: UITextField!
    @IBOutlet weak var imgToSave: UIImageView!
    

    override func viewWillDisappear(_ animated: Bool) {
        
//        if noteTextView.text != "Your new note here ...", noteTextView.text != "" {
//
//            dataManager.singleEntry.comment = noteTextView.text ?? ""
//            dataManager.singleEntry.date = getCurrentDate()
//            dataManager.singleEntry.time = getCurrentTime()
//            dataManager.singleEntry.address = address ?? ""
//            dataManager.singleEntry.lat = lat ?? 0.0
//            dataManager.singleEntry.lon = lon ?? 0.0
//            dataManager.singleEntry.timeStamp = NSDate()
//            dataManager.singleEntry.uID = uid!
//
//            if imgToSave.image != nil {
//                dataManager.singleEntry.img = imgToSave.image
//            }
//            dataManager.uploadData()
//        }
    }
    
    
    
    @IBAction func printDay(_ sender: Any) {
        print(getCurrentDay())
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = getCurrentDate()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
 
    
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

    @IBAction func takePicture(_ sender: Any) {
        
        
        
        
        //        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        //        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
        //            self.openCamera()
        //        }))
        //
        //        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
        //            self.openGallery()
        //        }))
        //        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        //        self.present(alert, animated: true, completion: nil)
    }

}

extension NewPostVC: UIImagePickerControllerDelegate {
    
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
        images?.append((info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!)
        dismiss(animated: true, completion: nil)
    }
}

