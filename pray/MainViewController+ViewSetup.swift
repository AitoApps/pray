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
        backgroundPatternImageView.imageGradientFadeTop(target: self)
    }
    
    func setupCurrentCityLabel() {
        let lines = DataSource.currentPlacemark.addressDictionary?["FormattedAddressLines"] as! NSArray
        let cityName = DataSource.currentPlacemark.locality ?? DataSource.currentPlacemark.subAdministrativeArea
        let line = lines[0] as! String
        cityNameLabel.text = cityName ?? line
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
            
            if let readableTime = timing.readableCompletionDate {
                if timing.name == Time.Fajr.rawValue {
                    fajrCompletion.text = readableTime
                } else if timing.name == Time.Dhuhr.rawValue {
                    dhuhrCompletion.text = readableTime
                } else if timing.name == Time.Asr.rawValue {
                    asrCompletion.text = readableTime
                } else if timing.name == Time.Maghrib.rawValue {
                    maghribCompletion.text = readableTime
                } else if timing.name == Time.Isha.rawValue {
                    ishaCompletion.text = readableTime
                }
            }
            
            if timing.name == Time.Imsak.rawValue {
                // imsakTimeLabel.text = timeFormatter.string(from: timing.date! as Date)
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
    
    // TODO: This function is messy. refactor it in the future
    func setupActiveTimingViewInteractor() {
        let now = Date()
        var passedTimings = [Timing]()
        
        // Label for passed time
        for time in timings {
            if now > time.date! as Date && time.name != "Imsak" && time.name != "Sunrise" {
                passedTimings.append(time)
            }
        }
        
        if passedTimings.count != 0 {
            for passedTiming in passedTimings {

                if passedTiming != passedTimings[passedTimings.count - 1] {
                    if passedTiming.completionDate == nil {
                        if passedTiming.name == Time.Fajr.rawValue {
                            self.fajrCompletion.text = "Time has passed and incompleted"
                            self.fajrTimingView.alpha = 0.5
                        } else if passedTiming.name == Time.Dhuhr.rawValue {
                            self.dhuhrCompletion.text = "Time has passed and incompleted"
                            self.dhuhrTimingView.alpha = 0.5
                        } else if passedTiming.name == Time.Asr.rawValue {
                            self.asrCompletion.text = "Time has passed and incompleted"
                            self.asrTimingView.alpha = 0.5
                        } else if passedTiming.name == Time.Maghrib.rawValue {
                            self.maghribCompletion.text = "Time has passed and incompleted"
                            self.maghribTimingView.alpha = 0.5
                        } else if passedTiming.name == Time.Isha.rawValue {
                            self.ishaCompletion.text = "Time has passed and incompleted"
                            self.ishaTimingView.alpha = 0.5
                        }
                    } else {
                        if passedTiming.name == Time.Fajr.rawValue {
                            self.fajrCompletion.text = passedTiming.readableCompletionDate
                            self.fajrTimingView.alpha = 0.5
                        } else if passedTiming.name == Time.Dhuhr.rawValue {
                            self.dhuhrCompletion.text = passedTiming.readableCompletionDate
                            self.dhuhrTimingView.alpha = 0.5
                        } else if passedTiming.name == Time.Asr.rawValue {
                            self.asrCompletion.text = passedTiming.readableCompletionDate
                            self.asrTimingView.alpha = 0.5
                        } else if passedTiming.name == Time.Maghrib.rawValue {
                            self.maghribCompletion.text = passedTiming.readableCompletionDate
                            self.maghribTimingView.alpha = 0.5
                        } else if passedTiming.name == Time.Isha.rawValue {
                            self.ishaCompletion.text = passedTiming.readableCompletionDate
                            self.ishaTimingView.alpha = 0.5
                        }
                    }
                } else {
                    if passedTiming.name == Time.Fajr.rawValue {
                        addGestureToView(view: fajrTimingView)
                        fajrTimingView.alpha = 1.0
                        fajrCompletion.text = "Tap to complete"
                    } else if passedTiming.name == Time.Dhuhr.rawValue {
                        addGestureToView(view: dhuhrTimingView)
                        dhuhrTimingView.alpha = 1.0
                        dhuhrCompletion.text = "Tap to complete"
                    } else if passedTiming.name == Time.Asr.rawValue {
                        addGestureToView(view: asrTimingView)
                        asrTimingView.alpha = 1.0
                        asrCompletion.text = "Tap to complete"
                    } else if passedTiming.name == Time.Maghrib.rawValue {
                        addGestureToView(view: maghribTimingView)
                        maghribTimingView.alpha = 1.0
                        maghribCompletion.text = "Tap to complete"
                    } else if passedTiming.name == Time.Isha.rawValue {
                        addGestureToView(view: ishaTimingView)
                        ishaTimingView.alpha = 1.0
                        ishaCompletion.text = "Tap to complete"
                    }
                }
            }
        }
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
