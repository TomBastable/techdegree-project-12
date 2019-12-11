//
//  PhotoOfTheDay.swift
//  NASA
//
//  Created by Tom Bastable on 10/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import Foundation

class PhotoOfTheDay {
    
    let url: String
    let descrip: String
    
    init(url: String, description: String) {
        
        
        self.url = url
        self.descrip = description
        
    }
    
    required convenience init?(json: [String: Any]) {
        
        struct Key {
            
            static let url = "url"
            static let description = "explanation"
            
        }
       
            
            guard let url = json[Key.url] as? String,
            let description = json[Key.description] as? String
            else {
                
                return nil
                
            }
        
        self.init(url: url, description: description)
        
    }
    
    
}
