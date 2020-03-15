//
//  Extension.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 27/2/2563 BE.
//  Copyright © 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageFromCache(urlImageString: String) {
        self.image = nil
        if let url = URL(string: urlImageString) {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if err != nil {
                    return
                }
                
                if let cacheImage = imageCache.object(forKey: urlImageString as AnyObject) as? UIImage {
                    DispatchQueue.main.async {
                        self.image = cacheImage
                    }
                }
                
                DispatchQueue.main.async {
                    if let downloadImage = UIImage(data: data!) {
                        imageCache.setObject(downloadImage, forKey: urlImageString as AnyObject)
                        self.image = UIImage(data: data!)
                    }
                    
                }
                
            }.resume()
        }
    }
}
