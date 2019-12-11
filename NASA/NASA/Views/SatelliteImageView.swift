//
//  SatelliteImageView.swift
//  NASA
//
//  Created by Tom Bastable on 10/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit
import MapKit

class SatelliteImageView: UIView {
    
    //MARK: - Properties
    
    @IBOutlet weak var satelliteImage: UIImageView!
    @IBOutlet weak var cloudPercentage: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK: - Setup View With Coordinate
    ///Sets the view up and displays satellite imagery based on the coordinate placed into the function.
    
    func setupViewWith(vc: UIViewController, coordinate: CLLocationCoordinate2D){
        
        //show the user the view is loading - disable close button to avoid confused re-loading.
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.closeButton.isHidden = true
        self.cloudPercentage.text = "Loading Imagery For That Location..."
        
        //unhide view
        self.isHidden = false
        
        //call api and retrieve imagery
        retrieveSatelliteImageryWith(latitude: coordinate.latitude.description, longitude: coordinate.longitude.description) { (satImage, error) in
            
            
            //check for no errors
            if error == nil {
                
                
                //safely unwrap satellite image
                guard let satImage = satImage.first else{
                    //image error
                    //no image for that location
                    DispatchQueue.main.async{
                        //display no imagery for that location to the user - Don't display an alert as it's not an error - there isn't any imagery for the location.
                        self.closeButton.isHidden = false
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.cloudPercentage.text = "No Satellite Imagery For That Location"
                    }
                    return
                }
                
                
                //get image url safely
                guard let url = URL(string: satImage.url) else{
                    //data error
                    DispatchQueue.main.async{
                    vc.displayAlertWith(error: HoustonError.responseUnsuccessful)
                    }
                    return
                }
                
                let data = try? Data(contentsOf: url)
                
                //safely get imagedata
                guard let imageData = data else{
                    //data error
                    DispatchQueue.main.async{
                    vc.displayAlertWith(error: HoustonError.invalidData)
                    }
                    return
                }
                
                //get the image
                let image = UIImage(data: imageData)
                //dispatch to main queue to change UI
                DispatchQueue.main.async{
                    //display load stop to UI
                    self.closeButton.isHidden = false
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    //set image
                    self.satelliteImage.image = image
                    //set text
                    self.cloudPercentage.text = "Precentage Of Cloud Cover In Above Image: \(satImage.cloudPercentage.rounded(toPlaces: 2)*100)%"
                }
            }else if error != nil{
                //error
                DispatchQueue.main.async{
                vc.displayAlertWith(error: error!)
                //display no imagery for that location to the user
                self.closeButton.isHidden = false
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.cloudPercentage.text = "Error downloading Satellite Image"
                }
            }
        }
    }
    
    //MARK: - Close View
    ///Closes view and resets properties
    
    @IBAction func closeView(_ sender: Any) {
        DispatchQueue.main.async{
        self.closeButton.isHidden = true
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.satelliteImage.image = nil
        self.cloudPercentage.text = nil
        self.isHidden = true
        }
    }
    
}
