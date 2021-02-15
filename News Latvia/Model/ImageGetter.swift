//
//  ImageGetter.swift
//  News Latvia
//
//  Created by karlis.stekels on 14/02/2021.
//

import Foundation

class ImageGetter{
    
    static func getImage(for url: String, comletion: @escaping(UIImage?) -> Void ){
        
        guard let imageUrl = URL(string: url) else {
            fatalError("could not create url this String \(url)")
        }
        
        Item.performRequest(for: imageUrl, httpMethod: .get) { (data, err) in
            guard let data = data, let image = UIImage(data: data) else{
                DispatchQueue.main.async { comletion(nil) }
                return
            }
            
            DispatchQueue.main.async { comletion(image) }
        }
    }
}
