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
    @IBOutlet weak var activeTimingNameLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var imsakTimeLabel: UILabel!
    @IBOutlet weak var fajrTimeLabel: UILabel!
    @IBOutlet weak var dhuhrTimeLabel: UILabel!
    @IBOutlet weak var asrTimeLabel: UILabel!
    @IBOutlet weak var maghribTimeLabel: UILabel!
    @IBOutlet weak var ishaTimeLabel: UILabel!
    
    @IBOutlet weak var backgroundPatternImageView: UIImageView!
    var timer = Timer()
    
    var seconds = Int()
    
    var activeTimingDate: Date? = nil
    
    var timings: Timings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarTransparent()
        setupTimingsLabel()
        setupCurrentCityLabel()
        setupActiveTimingDate {
            if activeTimingDate != nil {
                seconds = -(Date().seconds(from: activeTimingDate!))
                runTimer()
            }
            
        }
        
        setupBarButtonItem(image: #imageLiteral(resourceName: "settings"), position: .left)
        setupBarButtonItem(image: #imageLiteral(resourceName: "Qibla"), position: .right)
        
        let mask = CAGradientLayer()
        mask.startPoint = CGPoint(x: 1.0, y: 0.0)
        mask.endPoint = CGPoint(x:1.0, y:1.0)
        let whiteColor = UIColor.white
        mask.colors = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(1.0),whiteColor.withAlphaComponent(1.0).cgColor]
        mask.locations = [NSNumber(value: 0.0), NSNumber(value: 0.1), NSNumber(value: 1.0)]
        mask.frame = view.bounds
        backgroundPatternImageView.layer.mask = mask
    }
    
    enum BarButtonItemPosition {
        case left
        case right
    }
    
    func setupBarButtonItem(image: UIImage, position: BarButtonItemPosition) {
        let barButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
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
    
    func setupTimingsLabel() {
        let currentDate = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd MMM yyyy"
        let currentDateString = dayFormatter.string(from: currentDate)
        
        for timings in DataSource.calendar {
            if timings.day?.readable == currentDateString  {
                self.timings = timings
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
    
    func updateTimer() {
        seconds -= 1
        countDownLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(MainViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }

    
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}



