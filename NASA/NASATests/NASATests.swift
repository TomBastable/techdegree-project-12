//
//  NASATests.swift
//  NASATests
//
//  Created by Tom Bastable on 08/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import XCTest
@testable import NASA

class NASATests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSatelliteImage() {
        
        retrieveSatelliteImageryWith(latitude: "39.201790", longitude: "-90.584007") { (image, error) in
            XCTAssertFalse(error != nil)
        }
        
    }
    
    func testPOTDImage(){
        retrievePhotoOfTheDay { (photo, error) in
            XCTAssertFalse(error != nil)
        }
    }
    
    func testMarsWeather(){
        retrieveMarsWeather { (weather, error) in
            XCTAssertFalse(error != nil)
        }
    }
    
    func testRoverImage(){
        retrieveMarsRoverImagery { (roverImage, error) in
            XCTAssertFalse(error != nil)
        }
    }
    
    func testIncorrectCoordinateSatelliteImage(){
        
        retrieveSatelliteImageryWith(latitude: "", longitude: "") { (image, error) in
            XCTAssertFalse(error != nil)
        }
        
    }

}
