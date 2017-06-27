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
import UserNotifications

class MainViewController: PrayViewController, CLLocationManagerDelegate {
    
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
    
    // Views
    @IBOutlet weak var fajrTimingView: UIView!
    @IBOutlet weak var dhuhrTimingView: UIView!
    @IBOutlet weak var asrTimingView: UIView!
    @IBOutlet weak var maghribTimingView: UIView!
    @IBOutlet weak var ishaTimingView: UIView!
    
    @IBOutlet weak var fajrCompletion: UILabel!
    @IBOutlet weak var dhuhrCompletion: UILabel!
    @IBOutlet weak var asrCompletion: UILabel!
    @IBOutlet weak var maghribCompletion: UILabel!
    @IBOutlet weak var ishaCompletion: UILabel!
    
    let swipeGestureRecognizer = UISwipeGestureRecognizer()
    
    var timer = Timer()
    
    var seconds = Int()
    
    var activeTiming: Timing? = nil
    
    var day: Day!
    
    var timings: [Timing]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        setupUserNotification()
        createNotification()
        
        
        
        day = DataSource.today()
        initialViewSetup()
        setupSwipeGesture()
        countDownLabel.text = timeString(time: TimeInterval(seconds))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTimer()
        countDownLabel.text = timeString(time: TimeInterval(seconds))
        setupActiveTimingViewInteractor()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    
    
    func addGestureToView(view: UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(completionDidTap(sender:)))
        view.addGestureRecognizer(gesture)
    }

    
    func completionDidTap(sender: UITapGestureRecognizer) {
        let tag = sender.view!.tag
        let readableTime = Date().formatTimeToReadableTime()
        let date = Date()
        
        
        switch tag {
        case 1:
            fajrCompletion.text = "Completed at \(readableTime)"
            fajrTimingView.alpha = 0.5
            for timing in timings {
                if timing.name == Time.Fajr.rawValue {
                    updateCompletionDate(timing: timing, completedAt: date)
                }
            }
            
        case 2:
            dhuhrCompletion.text = "Completed at \(readableTime)"
            dhuhrTimingView.alpha = 0.5
            for timing in timings {
                if timing.name == Time.Dhuhr.rawValue {
                    updateCompletionDate(timing: timing, completedAt: date)
                }
            }
        case 3:
            asrCompletion.text = "Completed at \(readableTime)"
            asrTimingView.alpha = 0.5
            for timing in timings {
                if timing.name == Time.Asr.rawValue {
                    updateCompletionDate(timing: timing, completedAt: date)
                }
            }
        case 4:
            maghribCompletion.text = "Completed at \(readableTime)"
            maghribTimingView.alpha = 0.5
            for timing in timings {
                if timing.name == Time.Maghrib.rawValue {
                    updateCompletionDate(timing: timing, completedAt: date)
                }
            }
        default:
            ishaCompletion.text = "Completed at \(readableTime)"
            ishaTimingView.alpha = 0.5
            for timing in timings {
                if timing.name == Time.Isha.rawValue {
                    updateCompletionDate(timing: timing, completedAt: date)
                }
            }
        }
        
        
    }
    
    func setupTimer() {
        setupTimingsLabel()
        setupActiveTimingDate {
            if activeTiming != nil {
                seconds = -(Date().seconds(from: (activeTiming!.date as Date?)!))
                activeTimingNameLabel.text = activeTiming!.name
                runTimer()
            }
            
        }
    }
    
    func setupSwipeGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                presentSettings()
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                presentQibla()
                
            default:
                break
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

