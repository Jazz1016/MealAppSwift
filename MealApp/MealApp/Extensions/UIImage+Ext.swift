//
//  UIImage+Ext.swift
//  MealApp
//
//  Created by James Lea on 3/28/22.
//

import UIKit

extension UIImageView {
    
    func downloadImage(from urlString: String){
        
        let cacheKey = NSString(string: urlString)
        if let image = NetworkManager.shared.cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            
            NetworkManager.shared.cache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
    
}//End of Extension
