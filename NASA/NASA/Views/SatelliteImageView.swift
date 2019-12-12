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
        //show view is loading
        viewIsLoading()
        
        //unhide view
        self.isHidden = false
        
        //call api and retrieve imagery
        retrieveSatelliteImageryWith(latitude: coordinate.latitude.description, longitude: coordinate.longitude.description) { (satImage, error) in
            
            //check for no errors
            if error == nil {
                
                
                //safely unwrap satellite image
                guard let satImage = satImage.first else{
                    //no image for that location
                    DispatchQueue.main.async{
                        //display no imagery for that location to the user - Don't display an alert as it's not an error - there isn't any imagery for the location.
                        self.cloudPercentage.text = "No Satellite Imagery For That Location"
                    }
                    self.viewHasLoaded()
                    return
                }
                
                
                //get image url safely
                guard let url = URL(string: satImage.url) else{
                    //data error
                    DispatchQueue.main.async{
                    vc.displayAlertWith(error: HoustonError.responseUnsuccessful)
                    }
                    self.viewHasLoaded()
                    return
                }
                
                let data = try? Data(contentsOf: url)
                
                //safely get imagedata
                guard let imageData = data else{
                    //data error
                    DispatchQueue.main.async{
                    vc.displayAlertWith(error: HoustonError.invalidData)
                    }
                    self.viewHasLoaded()
                    return
                }
                
                //get the image
                let image = UIImage(data: imageData)
                //dispatch to main queue to change UI
                DispatchQueue.main.async{
                    //set image
                    self.satelliteImage.image = image
                    //set text
                    self.cloudPercentage.text = "Precentage Of Cloud Cover In Above Image: \(satImage.cloudPercentage.rounded(toPlaces: 2)*100)%"
                }
                self.viewHasLoaded()
            }else if error != nil{
                //error
                DispatchQueue.main.async{
                vc.displayAlertWith(error: error!)
                //display no imagery for that location to the user
                self.cloudPercentage.text = "Error downloading Satellite Image"
                }
                self.viewHasLoaded()
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
    
    func viewIsLoading(){
        //indicate the view is loading to the user
        DispatchQueue.main.async {
            self.closeButton.isHidden = true
            self.cloudPercentage.text = "Loading Imagery For That Location..."
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
    }
    
    func viewHasLoaded(){
        DispatchQueue.main.async {
            self.closeButton.isHidden = false
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
}
