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
    
    let swipeGestureRecognizer = UISwipeGestureRecognizer()
    
    var timer = Timer()
    
    var seconds = Int()
    
    var activeTiming: Timing? = nil
    
    var day: Day!
    
    var timings: [Timing]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        day = DataSource.today()
        initialViewSetup()
        setupTimingsLabel()
        setupActiveTimingDate {
            if activeTiming != nil {
                seconds = -(Date().seconds(from: (activeTiming!.date as Date?)!))
                activeTimingNameLabel.text = activeTiming!.name
                runTimer()
            }
            
        }
        
        
    }
    
    
    
    func presentSettings() {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    func presentQibla() {
        let storyboard = UIStoryboard(name: "Qibla", bundle: nil)
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "Qibla") as! QiblaViewController
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    func setupTimingsLabel() {
        let currentDate = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd MMM yyyy"
        let currentDateString = dayFormatter.string(from: currentDate)
        print(currentDateString)
        print(day)
        timings = preloadTimingsFromCoreData(for: day)
        
        for timing in timings {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            
            if timing.name == Time.Imsak.rawValue {
                imsakTimeLabel.text = timeFormatter.string(from: timing.date! as Date)
            } else if timing.name == Time.Fajr.rawValue {
                fajrTimeLabel.text = timeFormatter.string(from: timing.date! as Date)
            } else if timing.name == Time.Dhuhr.rawValue {
                dhuhrTimeLabel.text = timeFormatter.string(from: timing.date! as Date)
            } else if timing.name == Time.Asr.rawValue {
                asrTimeLabel.text = timeFormatter.string(from: timing.date! as Date)
            } else if timing.name == Time.Maghrib.rawValue {
                maghribTimeLabel.text = timeFormatter.string(from: timing.date! as Date)
            } else if timing.name == Time.Isha.rawValue {
                ishaTimeLabel.text = timeFormatter.string(from: timing.date! as Date)
            }
            
        }
    }
 
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            setupActiveTimingDate {
                if activeTiming != nil {
                    seconds = -(Date().seconds(from: (activeTiming!.date as Date?)!))
                    activeTimingNameLabel.text = activeTiming!.name
                    runTimer()
                }
            }
        } else {
            seconds -= 1
            countDownLabel.text = timeString(time: TimeInterval(seconds))
        }

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
