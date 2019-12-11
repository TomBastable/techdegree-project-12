//
//  EyeInSkyViewController.swift
//  NASA
//
//  Created by Tom Bastable on 10/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit
import MapKit

class EyeInSkyViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var satelliteImageView: SatelliteImageView!
    
    //MARK: - VDL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set dark move
        self.overrideUserInterfaceStyle = .dark
        //initilise tap recogniser
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EyeInSkyViewController.mapTapped))
        //set tap delegate
        gestureRecognizer.delegate = self
        //add recogniser to map.
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK: - Map Tapped
    /// Called when a tap gesture is detected. Adds a pin, displays satellite imagery of the tapped coordinate.
    
    @objc func mapTapped(gestureReconizer: UILongPressGestureRecognizer){
        //remove any previous annotations
        mapView.removeAnnotations(mapView.annotations)
        //get tap location
        let location = gestureReconizer.location(in: mapView)
        //convert to coordinate
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        // Add annotation and properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Previous Satellite Image Location"
        //add annotation
        mapView.addAnnotation(annotation)
        //load satellite imagery
        self.satelliteImageView.setupViewWith(vc: self, coordinate: coordinate)
        
    }

}
