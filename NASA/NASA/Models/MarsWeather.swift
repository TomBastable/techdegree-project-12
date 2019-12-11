//
//  MarsWeather.swift
//  NASA
//
//  Created by Tom Bastable on 10/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import Foundation

class MarsWeather {
    
    let low: Double
    let high: Double
    let sol: Int
    let earthDate: String
    
    init(low: Double, high: Double, sol:Int, earthDate: String) {
        
        
        let convertedDate = earthDate.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "MMMM d yyyy")
        
        self.low = low.rounded()
        self.high = high.rounded()
        self.sol = sol
        self.earthDate = convertedDate.uppercased()
        
    }
    
    required convenience init?(json: [String: Any]) {
        
        struct Key {
            
            static let low = "mn"
            static let high = "mx"
            static let sol = "currentSol"
            static let date = "First_UTC"
            static let current = "AT"
            
        }
       
            
            guard let current = json[Key.current] as? [String:Any],
            let low = current[Key.low] as? Double,
            let high = current[Key.high] as? Double,
            let sol = json[Key.sol] as? Int,
            let date = json[Key.date] as? String
            else {
                
                
                return nil
                
        }
        
        self.init(low: low, high: high, sol: sol, earthDate: date)
        
    }
    
    
}
