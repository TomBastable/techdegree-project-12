//
//  SatelliteImage.swift
//  NASA
//
//  Created by Tom Bastable on 10/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import Foundation

class SatelliteImage {
    
    let url: String
    let cloudPercentage: Double
    
    init(url: String, cloudPercentage: Double) {
        
        
        self.url = url
        self.cloudPercentage = cloudPercentage
        
    }
    
    required convenience init?(json: [String: Any]) {
        
        struct Key {
            
            static let url = "url"
            static let description = "cloud_score"
            
        }
       
            
            guard let url = json[Key.url] as? String,
            let cloudScore = json[Key.description] as? Double
            else {
                
                return nil
                
            }
        
        self.init(url: url, cloudPercentage: cloudScore)
        
    }
    
    
}
