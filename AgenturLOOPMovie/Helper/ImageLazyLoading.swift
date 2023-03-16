//
//  ImageLazyLoading.swift
//  AgenturLOOPMovie
//
//  Created by Jitengiri Goswami on 15/03/23.
//

import Foundation
import UIKit

class ImageLazyLoading: UIImageView{
    
    private let imageCache = NSCache<AnyObject, UIImage>()
    
    func loadImage(imageUrl: URL, placeHolderImage: String){
        
        self.image = UIImage(named: placeHolderImage)
        
        if let imgCache = self.imageCache.object(forKey: imageUrl as AnyObject){
            self.image = imgCache
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            
            if let imageData = try? Data(contentsOf: imageUrl){
                
                if let image = UIImage(data: imageData){
                    
                    DispatchQueue.main.async {
                        self?.imageCache.setObject(image, forKey: imageUrl as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
}
