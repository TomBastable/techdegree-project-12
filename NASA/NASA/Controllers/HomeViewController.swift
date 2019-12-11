//
//  ViewController.swift
//  NASA
//
//  Created by Tom Bastable on 08/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var solLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoOfTheDay: POTDView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: - VDL
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // setup mars' weather
        setupMarsWeather()
        //setup photo of the day
        photoOfTheDay.setup(with: self)
        //set dark mode
        self.overrideUserInterfaceStyle = .dark
        //setup scrollview
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(2), height: view.frame.height)
    
    }
    
    //MARK: - Setup Mars' Weather Data
    
    func setupMarsWeather(){
        //retrieve mars' weather from the api
        retrieveMarsWeather { (weather, error) in
            if error == nil{
                //safely unwrap
                guard let marsWeather = weather.first else{
                    self.displayAlertWith(error: HoustonError.responseUnsuccessful)
                    return
                }
                //dispatch to main from background
                DispatchQueue.main.async {
                    //set data to UI
                    self.highLabel.text = "\(marsWeather.high)"
                    self.lowLabel.text = "\(marsWeather.low)"
                    self.solLabel.text = "\(marsWeather.sol)"
                    self.dateLabel.addCharactersSpacing(spacing: 5, text: marsWeather.earthDate)
                }
            }else if error != nil {
                self.displayAlertWith(error: error!)
            }
        }
    }
    
    //MARK: - Scroll View Delegate
    
    //ensure no vertical scrolling occurs
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            scrollView.contentOffset.y = 0.0
    }
    
    //accurately set pageControl indicator
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
        self.pageControl.currentPage = Int(currentPage)

    }
    
}

