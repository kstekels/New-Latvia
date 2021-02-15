//
//  Item.swift
//  News Latvia
//
//  Created by karlis.stekels on 12/02/2021.
//

import Foundation
import Gloss

struct Item: JSONDecodable {
    
    var title: String
    var description: String
    var url: String
    var urlToImage: String
    
    init?(json: JSON) {
        self.title = "title" <~~ json ?? ""
        self.description = "description" <~~ json ?? ""
        self.url = "url" <~~ json ?? ""
        self.urlToImage = "urlToImage" <~~ json ?? ""
    }
    
    
}
