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
//        setupBarButtonItem(image: #imageLiteral(resourceName: "settings"), position: .left, selector: #selector(presentSettings))
//        setupBarButtonItem(image: #imageLiteral(resourceName: "Qibla"), position: .right, selector: #selector(presentQibla))
        backgroundPatternImageView.imageGradientFadeTop(target: self)
    }
    
    func setupCurrentCityLabel() {
        let lines = DataSource.currentPlacemark.addressDictionary?["FormattedAddressLines"] as! NSArray
        let cityName = DataSource.currentPlacemark.locality ?? DataSource.currentPlacemark.subAdministrativeArea
        let line = lines[0] as! String
        cityNameLabel.text = cityName ?? line
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

    func setupActiveTimingDate(completion: () -> Void) {
        let currentTime = Date()
        var timingsHasNotPassedYet: [Timing] = []
        
        for timing in timings {
            if timing.date! as Date > currentTime {
                timingsHasNotPassedYet.append(timing)
            }
        }
        
        timingsHasNotPassedYet = timingsHasNotPassedYet.sorted(by: { ($0.date! as Date) < ($1.date! as Date) })
        if timingsHasNotPassedYet.count != 0 {
            self.activeTiming = timingsHasNotPassedYet[0]
        } else {
            self.activeTiming = nil
        }
        completion()
    }
}
