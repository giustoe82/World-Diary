//
//  FullScreenPicVC.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-21.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit
import Firebase
import FacebookShare
import FacebookLogin

class FullScreenPicVC: UIViewController {

    @IBOutlet weak var imageLarge: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    var imageToShow: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func shareAction(_ sender: Any) {
        facebookShare(image: imageLarge.image!)
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
                        self.imageLarge.image = myImg
                    }
                }
            }
        }
    }
    
    func facebookShare(image: UIImage) {
        let photo = Photo(image: image, userGenerated: true)
        let myContent = PhotoShareContent(photos: [photo])
        let shareDialog = ShareDialog(content: myContent)
        shareDialog.presentingViewController = self
        shareDialog.mode = .automatic
        shareDialog.completion = { result in
            print("- in completion")
        }
        do {
            try shareDialog.show()
        } catch {
            print(error)
        }
    }
    
}
