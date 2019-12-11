//
//  PostcardView.swift
//  NASA
//
//  Created by Tom Bastable on 11/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit
import Foundation

class PostcardView: UIView, UITextViewDelegate {
    
    //MARK: - Properties
    
    ///Provides the max chars for the text view.
    //this may need to be a computed property in future to allow for autolayout when it's implemented.
    private let maxChars: Int = 170
    @IBOutlet weak var marsImageView: UIImageView!
    @IBOutlet weak var postcardCaptionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Setup Postcard
    ///Sets up the postcard view with a random image from the curiosity rover. 
    func setupPostcard(with vc: UIViewController) {
        //indicate the view is loading in the UI
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        //call the API
        retrieveMarsRoverImagery { (images, error) in
            //check that there aren't any errors
            if error == nil{
                //safely assign photo
                guard let photo = images.first else{
                    DispatchQueue.main.async{
                    vc.displayAlertWith(error: HoustonError.responseUnsuccessful)
                    }
                    return
                }
                //get url and safely get data
                let url = URL(string: photo.url)
                let data = try? Data(contentsOf: url!)
                guard let imageData = data else {
                    DispatchQueue.main.async{
                    vc.displayAlertWith(error: HoustonError.invalidData)
                    }
                    return
                }
                //assign image from data
                let image = UIImage(data: imageData)
                //dispatch to the main queue from the background to change the UI.
                DispatchQueue.main.async{
                    //assign image
                    self.marsImageView.image = image
                    //indicate in the UI it has loaded
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
                
            }else{
                //error
                DispatchQueue.main.async{
                    vc.displayAlertWith(error: error!)
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.textView.text = error!.localizedDescription
                }
                //indicate in the UI it has finished
                
            }
        }
    }
    
    //MARK: - Text View Delegate Methods
    
    //check for return button press, hide keyboard.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    //check for stock placeholder - remove it. text view doesn't have the ability to have a placeholder, this was a workaround.
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "    Tap here to type a caption for your postcard!"{
            textView.text = ""
        }
    }
    //ensure the input doesn't exceed the max chars.
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.count)
        
        if textView.text.count >= maxChars {

            while textView.text.count >= maxChars{
            
                textView.text.remove(at: textView.text.index(before: textView.text.endIndex))
                
            }
        }
    }
}
