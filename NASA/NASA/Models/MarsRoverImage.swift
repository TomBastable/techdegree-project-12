//
//  MarsRoverImage.swift
//  NASA
//
//  Created by Tom Bastable on 11/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import Foundation

class MarsRoverImage {
    
    let url: String
    
    init(url: String) {
        
        
        self.url = url
        
    }
    
    required convenience init?(json: [String: Any]) {
        
        struct Key {
            
            static let url = "img_src"
            
        }
       
            
            guard let url = json[Key.url] as? String
            else {
                
                return nil
                
            }
        
        self.init(url: url)
        
    }
    
    
}
