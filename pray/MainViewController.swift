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
    
    let longPressGestureRecognizer = UISwipeGestureRecognizer()
    
    var timer = Timer()
    
    var seconds = Int()
    
    var activeTimingDate: Date? = nil
    
    var day: Day!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        day = DataSource.today()
        initialViewSetup()
        
//        setupActiveTimingDate {
//            if activeTimingDate != nil {
//                seconds = -(Date().seconds(from: activeTimingDate!))
//                runTimer()
//            }
//            
//        }
        
        
    }
    
    func presentSettings() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let settings = storyboard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        self.present(settings, animated: false, completion: nil)
    }
    
    func setupTimingsLabel() {
        let currentDate = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd MMM yyyy"
        let currentDateString = dayFormatter.string(from: currentDate)
        
        
        /*
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
        */
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
