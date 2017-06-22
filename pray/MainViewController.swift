//
//  MainViewController.swift
//  pray
//
//  Created by Zulwiyoza Putra on 5/24/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var imsakTimeLabel: UILabel!
    @IBOutlet weak var fajrTimeLabel: UILabel!
    @IBOutlet weak var dhuhrTimeLabel: UILabel!
    @IBOutlet weak var asrTimeLabel: UILabel!
    @IBOutlet weak var maghribTimeLabel: UILabel!
    @IBOutlet weak var ishaTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimingsLabel()
        setupCurrentCityLabel()

    }
    
    func setupTimingsLabel() {
        let currentDate = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd MMM yyyy"
        let currentDateString = dayFormatter.string(from: currentDate)
        
        for timings in DataSource.calendar {
            if timings.day?.readable == currentDateString  {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "h:mm a"
                imsakTimeLabel.text = timeFormatter.string(from: timings.imsak! as Date)
                fajrTimeLabel.text = timeFormatter.string(from: timings.fajr! as Date)
                dhuhrTimeLabel.text = timeFormatter.string(from: timings.dhuhr! as Date)
                asrTimeLabel.text = timeFormatter.string(from: timings.asr! as Date)
                maghribTimeLabel.text = timeFormatter.string(from: timings.maghrib! as Date)
                ishaTimeLabel.text = timeFormatter.string(from: timings.isha! as Date)
            }
        }
    }
    
    func setupCurrentCityLabel() {
        let lines = DataSource.placemark.addressDictionary?["FormattedAddressLines"] as! NSArray
        let line = lines[0] as! String
        cityNameLabel.text = line
    }

    
}



