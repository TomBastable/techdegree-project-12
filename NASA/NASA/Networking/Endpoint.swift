//
//  Endpoint.swift
//  NASA
//
//  Created by Tom Bastable on 10/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import Foundation

fileprivate let apiKey: URLQueryItem = URLQueryItem(name: "api_key", value: "qfdsva0so8gwohWx4PNYMbqtMQNnTWhbD7zEyEBF")


protocol Endpoint {
    
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    
}

extension Endpoint {
    
    var urlComponents: URLComponents {
        
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        
        return components
    }
    
    var request: URLRequest {
        
        let url = urlComponents.url!
        return URLRequest(url: url)
        
    }
    
}

enum NASAEndpoints {
    
    case marsWeather
    case photoOfTheDay
    case earthImagery(lat: String, lon: String)
    case marsRoverImagery
}

extension NASAEndpoints: Endpoint {
    
    var base: String {
        return "https://api.nasa.gov"
    }
    
    var path: String {
        
        switch self {
            
        case .marsWeather: return "/insight_weather/"
        case .photoOfTheDay: return "/planetary/apod"
        case .earthImagery: return "/planetary/earth/imagery/"
        case . marsRoverImagery: return "/mars-photos/api/v1/rovers/curiosity/photos"
            
        }
        
    }
    
    var queryItems: [URLQueryItem] {
        
    switch self {
        
    case .marsWeather:
        
        var result = [URLQueryItem]()
        let feedType: URLQueryItem = URLQueryItem(name: "feedtype", value: "json")
        result.append(feedType)
        let version: URLQueryItem = URLQueryItem(name: "ver", value: "1.0")
        result.append(version)
        result.append(apiKey)
        
        return result
        
    case .photoOfTheDay:
        return [apiKey]
    
    case .earthImagery(let lat, let lon):
        
        var result = [URLQueryItem]()
        let lat: URLQueryItem = URLQueryItem(name: "lat", value: lat)
        result.append(lat)
        let lon: URLQueryItem = URLQueryItem(name: "lon", value: lon)
        result.append(lon)
        let dim: URLQueryItem = URLQueryItem(name: "dim", value: "0.25")
        result.append(dim)
        let cloudPercentage: URLQueryItem = URLQueryItem(name: "cloud_score", value: "true")
        result.append(cloudPercentage)
        result.append(apiKey)
        
        return result
        
    case .marsRoverImagery:
        
        var result = [URLQueryItem]()
        let page: URLQueryItem = URLQueryItem(name: "page", value: "\(Int.random(in: 0 ..< 10))")
        result.append(page)
        let sol: URLQueryItem = URLQueryItem(name: "sol", value: "1000")
        result.append(sol)
        result.append(apiKey)
        return result
        
        }
    }
    
    func getEarthQueryItems(){
        
    }
    
}
