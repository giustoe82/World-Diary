//
//  DBManager.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-12.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation


protocol DataDelegate {
    func reload()
    
}

struct Day {
    var opened = Bool()
    var date: String?
    var sectionData: [Entry]?
    var tableIndex = Int()
    
}

struct Entry {
    var id = ""
    var imgUrl = ""
    var img: UIImage?
    var thumbUrl = ""
    var thumb: UIImage?
    var comment = ""
    var date = ""
    var time = ""
    var lat: Double?
    var lon: Double?
    var address = ""
    var uID = ""
    var timeStamp: Timestamp?
    var dayLiteral = ""
}

class DBManager {
    
    var dataDel: DataDelegate?
    
    let userID = Auth.auth().currentUser?.uid
    
    var EntriesArray:[Entry] = []
    var filteredEntries:[Entry] = []
    var entriesWithImage:[Entry] = []
    var imageNames:[String] = []
    var singleEntry = Entry()
    
    var myArray: [Entry] = []
    var days: [Day] = []
    var newDay: Day?
    
    
    
    
    /*
     *Fetching data from database: everything taken from firestore (all but pics) is stored in structs which
     *are grouped in an array. The array elements are ordered by the property timestamp present in each struct
     */
    
    
    func loadDB() {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        db.collection("Entries2").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let qSnapshot = querySnapshot else {return}
                for document in qSnapshot.documents {
                    self.singleEntry = Entry()
                    self.singleEntry.id = document.documentID
                    self.singleEntry.comment = document.data()["comment"] as? String ?? ""
                    self.singleEntry.date = document.data()["date"] as? String ?? ""
                    self.singleEntry.time = document.data()["time"] as? String ?? ""
                    self.singleEntry.address = document.data()["address"] as? String ?? ""
                    self.singleEntry.lat = document.data()["lat"] as? Double ?? nil
                    self.singleEntry.lon = document.data()["lon"] as? Double ?? nil
                    self.singleEntry.imgUrl = document.data()["img"] as? String ?? ""
                    self.singleEntry.thumbUrl = document.data()["thumb"] as? String ?? ""
                    self.singleEntry.timeStamp = document.data()["timestamp"] as? Timestamp
                    self.singleEntry.dayLiteral = document.data()["dayliteral"] as? String ?? ""
                    self.EntriesArray.append(self.singleEntry)
                    
                    if self.singleEntry.imgUrl != "" {
                       self.entriesWithImage.append(self.singleEntry)
                     }
                }
                self.EntriesArray.sort(by: { (lhs:Entry, rhs:Entry) -> Bool in
                    (lhs.timeStamp?.dateValue().timeIntervalSince1970 ?? 0) > (rhs.timeStamp?.dateValue().timeIntervalSince1970 ?? 0)
                })
                self.entriesWithImage.sort(by: { (lhs:Entry, rhs:Entry) -> Bool in
                    (lhs.timeStamp?.dateValue().timeIntervalSince1970 ?? 0) > (rhs.timeStamp?.dateValue().timeIntervalSince1970 ?? 0)
                })
                self.loadThumbs()
                }
            }
        }
    
    func loadDBtoCollection() {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("Entries2").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let qSnapshot = querySnapshot else {return}
                for document in qSnapshot.documents {
                    
                    self.singleEntry = Entry()
                    self.singleEntry.id = document.documentID
                    self.singleEntry.timeStamp = document.data()["timestamp"] as? Timestamp
                    self.singleEntry.imgUrl = document.data()["img"] as? String ?? ""
                    
                    self.EntriesArray.append(self.singleEntry)
                    
                    if self.singleEntry.imgUrl != "" {
                        self.entriesWithImage.append(self.singleEntry)
                    }
                }
                self.EntriesArray.sort(by: { (lhs:Entry, rhs:Entry) -> Bool in
                    (lhs.timeStamp?.dateValue().timeIntervalSince1970 ?? 0) > (rhs.timeStamp?.dateValue().timeIntervalSince1970 ?? 0)
                    
                })
                self.entriesWithImage.sort(by: { (lhs:Entry, rhs:Entry) -> Bool in
                    (lhs.timeStamp?.dateValue().timeIntervalSince1970 ?? 0) > (rhs.timeStamp?.dateValue().timeIntervalSince1970 ?? 0)
                    
                })
                DispatchQueue.main.async {
                    self.delayWithSeconds(1.5) {
                        self.dataDel?.reload()
                    }
                }
            }
        }
    }
    
    
    
    func getEntries() -> [Entry] {
        return EntriesArray
    }
    
    //together with the structs we load the thumbs that are going to be shown in the tableView
    func loadThumbs() {
        
        let storageRef = Storage.storage().reference()
            for (index,var entry) in self.EntriesArray.enumerated() {
            let imgRef = storageRef.child(entry.thumbUrl)
                
            imgRef.getData(maxSize: 1024*1024) { data, error in
                if let error = error {
                    print(error)
                } else {
                    if let thumbData = data {
                        entry.thumb = UIImage(data: thumbData)
                        self.EntriesArray[index] = entry
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.delayWithSeconds(1.5) {
                
                self.dataDel?.reload()
            }

            
        }
    }
    
    //---------------------------------------------------------------------------------
    
    func deleteFromDB(position: Int) {
        let db = Firestore.firestore()
        let deleteID = EntriesArray[position].id
        db.collection("Entries2").document(deleteID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func deleteImage(position: Int) {
        let name = EntriesArray[position].imgUrl
        let storageRef = Storage.storage().reference()
        let deleteRef = storageRef.child(name)
        
        // Delete the file
        deleteRef.delete { error in
            if let error = error {
                print(error)
            } else {
                print("Image successfully deleted")
            }
        }
    }
    
    func deleteThumb(position: Int) {
        let name = EntriesArray[position].thumbUrl
        let storageRef = Storage.storage().reference()
        let deleteRef = storageRef.child(name)
        
        // Delete the file
        deleteRef.delete { error in
            if let error = error {
                print(error)
            } else {
                print("Thumb successfully deleted")
            }
        }
    }
    func uploadImage(imgName: String) {
        
        if let image = singleEntry.img  {
            let width = UIScreen.main.bounds.size.width
            let height = UIScreen.main.bounds.size.height
            UIGraphicsBeginImageContext(CGSize(width: width, height: height))
            let ratio = CGFloat(width / height)
            let scaleWidth = width
            let scaleHeight = width / ratio
            let offsetX = CGFloat(0.0)
            let offsetY = CGFloat((scaleHeight - height)/2.0)
            image.draw(in: CGRect(x: -offsetX, y: -offsetY, width: scaleWidth, height: scaleHeight))
            let largeImg = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let largeImg = largeImg, let jpegData = largeImg.jpegData(compressionQuality: 0.7) {
                let storageRef = Storage.storage().reference()
                let imgRef = storageRef.child(imgName+".jpg")
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                //metadata.customMetadata = (["id" : userID] as! [String : String])
                
                imgRef.putData(jpegData, metadata: metadata) { (metadata, error) in
                    guard metadata != nil else {
                        print(error!)
                        return
                    }
                    print("image uploaded")
                    self.uploadThumb(imgName: imgName)
                }
            }
        }
    }
    
    func uploadThumb(imgName:String) {
        if let image = singleEntry.img {
            UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
            let ratio = Double(image.size.width/image.size.height)
            let scaleWidth = ratio * 100.0
            let scaleHeight = 100.0
            let offsetX = (scaleWidth-100)/2.0
            let offsetY = 0.0
            image.draw(in: CGRect(x: -offsetX, y: -offsetY, width: scaleWidth, height: scaleHeight))
            
            let thumb = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let thumb = thumb, let jpegData = thumb.jpegData(compressionQuality: 0.7) {
                let storageRef = Storage.storage().reference()
                let imgRef = storageRef.child(imgName+"_thumb.jpg")
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                imgRef.putData(jpegData, metadata: metadata) { (metadata, error) in
                    guard metadata != nil else {
                        print(error!)
                        return
                    }
                    print("thumb uploaded")
                }
            }
        }
    }
    
    func loadImage(imgUrl:String)  {
        
        let storageRef = Storage.storage().reference()
        let imgRef = storageRef.child(imgUrl)
        imgRef.getData(maxSize: 2048*2048) { data, error in
            if let error = error {
                print(error)
            } else {
                if let imgData = data {
                    
                    if let myImg = UIImage(data: imgData) {
                        
                        self.singleEntry.img = myImg
                        
                    }
                }
            }
        }
    }
    
    
    
    func uploadData() {
        
        var imgName = imgNameFromDate(time: NSDate()).replacingOccurrences(of: " ", with: "_")
        imgName = imgName.replacingOccurrences(of: ",", with: "_")
        imgName = imgName.replacingOccurrences(of: "-", with: "_")
        imgName = imgName.replacingOccurrences(of: ":", with: "")
        
        let db = Firestore.firestore()
        
        var dataDict: [String: Any] = [
            "date": singleEntry.date ,
            "time": singleEntry.time ,
            "comment": singleEntry.comment,
            "timestamp": singleEntry.timeStamp!,
            "address": singleEntry.address,
            "lat": singleEntry.lat ?? 0.0,
            "lon": singleEntry.lon ?? 0.0,
            "uid": singleEntry.uID,
            "dayliteral": singleEntry.dayLiteral
        ]
        
        if singleEntry.img != nil {
            dataDict["img"] = imgName + ".jpg"
            dataDict["thumb"] = imgName + "_thumb.jpg"
        } else {
            dataDict["img"] = ""
            dataDict["thumb"] = ""
        }
        
        
        db.collection("Entries2").document().setData(dataDict) { err in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("Entry uploaded in database")
                if self.singleEntry.img != nil {
                    self.uploadImage(imgName: imgName)
                }
            }
        }
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
    func imgNameFromDate(time: NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        let str = formatter.string(from: NSDate() as Date)
        return str
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}

//protocol DBProtocol: class {
//    func fillWith(myArray:[Entry]) -> [Day]
//    func loadDB()
//    func getEntries() -> [Entry]
//    func loadThumbs()
//    func deleteFromDB(position: Int)
//    func deleteImage(position: Int)
//    func deleteThumb(position: Int)
//    func uploadImage(imgName: String)
//    func uploadThumb(imgName:String)
//    func loadImage(imgUrl:String)
//    func uploadData()
//    func imgNameFromDate(time: NSDate) -> String
//}

