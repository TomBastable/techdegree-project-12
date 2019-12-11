//
//  POTDView.swift
//  NASA
//
//  Created by Tom Bastable on 10/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit
import Foundation


///Photo of the day view. Fetches NASA's most recent astronomy photo of the day and displays it in its own view.
class POTDView: UIView {
    
    //MARK: - Properties
    ///The image view inside the POTDView. The POTD will be displayed in this.
    @IBOutlet weak var photoOfTheDay: UIImageView!
    ///This label will display the description of the POTD.
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Setup View
    ///Call this function to setup the view. no input needed.
    func setup(with vc: UIViewController) {
        
        //indicate the view is loading to the user
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        //call the API
        retrievePhotoOfTheDay { (photo, error) in
            
            //check for no errors
            if error == nil{
                //assign the photo from the array
                guard let thePhoto = photo.first else {
                    DispatchQueue.main.async {
                      vc.displayAlertWith(error: HoustonError.responseUnsuccessful)
                    }
                    return
                }
                //get the photos url
                guard let url = URL(string: thePhoto.url) else{
                    DispatchQueue.main.async {
                      vc.displayAlertWith(error: HoustonError.responseUnsuccessful)
                    }
                    return
                }
                //get the image data
                let data = try? Data(contentsOf: url)
                
                guard let imageData = data else {
                    DispatchQueue.main.async {
                      vc.displayAlertWith(error: HoustonError.invalidData)
                    }
                    return
                }
                //assign image from data
                let image = UIImage(data: imageData)
                //dispatch to main to change UI
                DispatchQueue.main.async{
                    //set photo and description
                    self.photoOfTheDay.image = image
                    self.descriptionlabel.text = thePhoto.descrip
                    //show the view has loaded
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                
        
            }
            else if error != nil{
                //error
                //display loading is done to UI
                DispatchQueue.main.async {
                    vc.displayAlertWith(error: error!)
                    self.descriptionlabel.text = error!.localizedDescription
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                
            }
        }
        
    }
    
    
    
}
