//
//  UIImage + Extension.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-14.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func cacheImage(urlString: String) {
        
        guard let url = URL(string: urlString) else {return}
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        print(url)
        // urlString    String    "/var/mobile/Containers/Data/Application/4C54C0FE-9E29-4370-8059-E50CE6D3CD64/Documents/styles/style_1.png"
        if let image = UIImage(contentsOfFile: urlString) {
            
            imageCache.setObject(image, forKey: urlString as AnyObject)
            self.image = image
        } else {
            URLSession.shared.dataTask(with: url) {
                data, response, error in
                if data != nil {
                    DispatchQueue.main.async {
                        if let imageToCache = UIImage(data: data!) {
                            imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                            self.image = imageToCache
                        }
                    }
                }
                }.resume()
        }
    }
}

