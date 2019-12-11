//
//  RoverPostcardViewController.swift
//  NASA
//
//  Created by Tom Bastable on 10/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit
import MessageUI

class RoverPostcardViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var postCardView: PostcardView!
    
    //MARK: - VDL
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //set dark mode
        self.overrideUserInterfaceStyle = .dark
        // Do any additional setup after loading the view.
        self.postCardView.setupPostcard(with: self)
        //setup keyboard KVO
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //MARK: - Send Postcard
    
    @IBAction func sendPostcard(_ sender: Any) {
        
        //Please be aware this will not function in a simulator - this has to be tested on a device.
        
        //check if device is setup for mail.
           if MFMailComposeViewController.canSendMail() {
            //initiate controller
             let mail = MFMailComposeViewController()
            //set delegate
             mail.mailComposeDelegate = self;
            //set receipients
             mail.setCcRecipients(["programmingmemes@freddyvJSON.com"])
            //set subject
             mail.setSubject("Elon Musk Says Hello!")
            //message body
             mail.setMessageBody("This is a super a", isHTML: false)
            //safely grab an image of the postcard view.
            guard let imageData: Data = self.postCardView.asImage().pngData() else{
                //display error
                self.displayAlertWith(error: HoustonError.invalidData)
                return
            }
            //add the attachment
             mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "imageName.png")
            //present the controller
            self.present(mail, animated: true, completion: nil)
            
           }else{
            //device is not setup for mail - display error
            self.displayAlertWith(error: HoustonError.mailSetupError)
        }
    }
    
    //MARK: - Mail Composer Did Finish
    
    private func mailComposeController(controller: MFMailComposeViewController,
        didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        //dismiss controller
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Keyboard will show / will hide
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.postCardView.frame.origin.y == 113 {
                //move postcard view above keyboard
                self.postCardView.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.postCardView.frame.origin.y != 113 {
            //move postcard view back to original y coordinate
            self.postCardView.frame.origin.y = 113
        }
    }
    
}
