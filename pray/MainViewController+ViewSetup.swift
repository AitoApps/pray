//
//  MainViewController+ViewSetup.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/23/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit

enum BarButtonItemPosition {
    case left
    case right
}

extension MainViewController {
    
    func initialViewSetup() {
        setupNavigationBarTransparent()
        setupTimingsLabel()
        setupCurrentCityLabel()
        setupBarButtonItem(image: #imageLiteral(resourceName: "settings"), position: .left, selector: #selector(presentSettings))
        setupBarButtonItem(image: #imageLiteral(resourceName: "Qibla"), position: .right, selector: nil)
        setupBackgroundImageGradient()
    }
    
    func setupCurrentCityLabel() {
        let lines = DataSource.currentPlacemark.addressDictionary?["FormattedAddressLines"] as! NSArray
        let line = lines[0] as! String
        cityNameLabel.text = line
    }
    
    func setupBackgroundImageGradient() {
        let mask = CAGradientLayer()
        mask.startPoint = CGPoint(x: 1.0, y: 0.0)
        mask.endPoint = CGPoint(x:1.0, y:1.0)
        let whiteColor = UIColor.white
        mask.colors = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(1.0),whiteColor.withAlphaComponent(1.0).cgColor]
        mask.locations = [NSNumber(value: 0.0), NSNumber(value: 0.1), NSNumber(value: 1.0)]
        mask.frame = view.bounds
        backgroundPatternImageView.layer.mask = mask
    }
    
    func setupBarButtonItem(image: UIImage, position: BarButtonItemPosition, selector: Selector?) {
        let barButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: selector)
        barButtonItem.tintColor = .white
        switch position {
        case .left:
            navigationItem.leftBarButtonItem = barButtonItem
        case .right:
            navigationItem.rightBarButtonItem = barButtonItem
        }
    }
    
    func setupNavigationBarTransparent() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackOpaque
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    /*
    func setupActiveTimingDate(completion: () -> Void) {
        let currentTime = Date()
        var timingsHasNotPassedYet: [Date] = []
        
        if timings.fajr! as Date > currentTime as Date {
            
            if timingsHasNotPassedYet.count == 0 {
                activeTimingNameLabel.text = "Fajr"
            }
            
            timingsHasNotPassedYet.append(timings.fajr! as Date)
        }
        
        if timings.dhuhr! as Date > currentTime as Date {
            
            if timingsHasNotPassedYet.count == 0 {
                activeTimingNameLabel.text = "Dhuhr"
            }
            
            timingsHasNotPassedYet.append(timings.dhuhr! as Date)
        }
        
        if timings.asr! as Date > currentTime as Date {
            
            if timingsHasNotPassedYet.count == 0 {
                activeTimingNameLabel.text = "Asr"
            }
            
            timingsHasNotPassedYet.append(timings.asr! as Date)
        }
        
        if timings.maghrib! as Date > currentTime as Date {
            
            if timingsHasNotPassedYet.count == 0 {
                activeTimingNameLabel.text = "Maghrib"
            }
            
            timingsHasNotPassedYet.append(timings.maghrib! as Date)
        }
        
        if timings.isha! as Date > currentTime as Date {
            
            if timingsHasNotPassedYet.count == 0 {
                activeTimingNameLabel.text = "Isha"
            }
            
            timingsHasNotPassedYet.append(timings.isha! as Date)
        }
        
        if timingsHasNotPassedYet.count != 0 {
            self.activeTimingDate = timingsHasNotPassedYet[0]
        } else {
            self.activeTimingDate = nil
        }
        completion()
    }
    */
}
