//
//  HoustonAPI.swift
//  NASA
//
//  Created by Tom Bastable on 10/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import Foundation

let downloader = JSONDownloader()

typealias Results = [String: Any]

//MARK: - Retrieve Mars Rover Imagery
///Retrieves a single random photo from the curiosity rover.

func retrieveMarsRoverImagery(completion: @escaping ([MarsRoverImage], HoustonError?) -> Void){
    
    let endpoint = NASAEndpoints.marsRoverImagery.request
    
    performRequest(with: endpoint) { result, error in
        guard let result = result else {
            completion([], error)
            return
        }
        
        let results = [result]
        
        let image = results.compactMap { MarsRoverImage(json: $0) }

        completion(image, nil)
    }
    
}

//MARK: - Retrieve Satellite Imagery
///Function takes in coordinates in order to retrieve a relevant satellite image.

func retrieveSatelliteImageryWith(latitude lat:String, longitude lon:String, completion: @escaping ([SatelliteImage], HoustonError?) -> Void){
    
    let endpoint = NASAEndpoints.earthImagery(lat: lat, lon: lon).request
    
    performRequest(with: endpoint) { result, error in
        guard let result = result else {
            completion([], error)
            return
        }
        
        let results = [result]
        
        let image = results.compactMap { SatelliteImage(json: $0) }
        
        completion(image, nil)
    }
}

//MARK: - Retrieve Mars Weather
///Retrieves todays weather from Mars.

func retrieveMarsWeather(completion: @escaping ([MarsWeather], HoustonError?) -> Void){
    
    let endpoint = NASAEndpoints.marsWeather.request
    
    performRequest(with: endpoint) { result, error in
        guard let result = result else {
            completion([], error)
            return
        }
        
        let results = [result]
        
        let weather = results.compactMap { MarsWeather(json: $0) }
        
        completion(weather, nil)
    }
    
}

//MARK: - Retrieve Photo Of The Day
///Retrieves a single instance of POTD.

func retrievePhotoOfTheDay(completion: @escaping ([PhotoOfTheDay], HoustonError?) -> Void){
    
    let endpoint = NASAEndpoints.photoOfTheDay.request
    
    performRequest(with: endpoint) { result, error in
        guard let result = result else {
            completion([], error)
            return
        }
        
        let results = [result]
        
        let photo = results.compactMap { PhotoOfTheDay(json: $0) }
        
        completion(photo, nil)
    }
    
}

private func performRequest(with endpoint: URLRequest, completion: @escaping (Results?, HoustonError?) -> Void) {
    
    let task = downloader.jsonTask(with: endpoint) { json, error in
        
            guard let json = json else {
                completion(nil, error)
                return
            }
            
        //Similar thing with genres
        if endpoint == NASAEndpoints.marsWeather.request{
                
            guard let currentSolRange = json["sol_keys"] as? [String] else {
                completion(nil, .jsonParsingFailure)
                return
            }
            
            var intArray: [Int] = []
            
            for result:String in currentSolRange { intArray.append(Int(result)!) }
            
            var currentSol: Int = 0
            
            //check to see if it's the beginning of a new martian year
            if intArray.contains(1) && intArray.contains(668) {
                
            }else{
                
                currentSol = intArray.max()!
            }
            
            guard var currentSolData = json["\(currentSol)"] as? [String: Any] else {
                completion(nil, .jsonParsingFailure)
                return
            }
            
            currentSolData.updateValue(currentSol, forKey: "currentSol")
            
            completion(currentSolData, nil)
                
        }
            
        else if endpoint == NASAEndpoints.photoOfTheDay.request{
                
            completion (json, nil)
                
        }
            
        else if endpoint.url?.path == NASAEndpoints.marsRoverImagery.request.url?.path{
            
            guard let photos = json["photos"] as? [[String: Any]] else {
                completion(nil, .jsonParsingFailure)
                return
            }
            
            let randomPhoto = photos[Int.random(in: 0 ..< photos.count)]
            completion(randomPhoto, nil)
            
        }
        else {
            completion (json, nil)
        }
        
            //completion(results, nil)
        
    }
    
    task.resume()
    
}

