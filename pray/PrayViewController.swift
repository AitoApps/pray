//
//  AbstractViewController.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/24/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import UserNotifications

class PrayViewController: UIViewController, CAAnimationDelegate, UNUserNotificationCenterDelegate {

    let transition = CATransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transition.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUserNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow: Bool, error: Error?) in
            if didAllow {
                print("Allowed")
            } else {
                print("Not allowed please go to settings to allow notification")
            }
        }
    }
    
    // Mark: Notification
    func createNotification() {
        let remindIn15Mins = UNNotificationAction(identifier: "remindIn15Mins", title: "Remind me in 15 minutes", options: .destructive)
        let remindIn30Mins = UNNotificationAction(identifier: "remindIn30Mins", title: "Remind me in 30 minutes", options: .destructive)
        let done = UNNotificationAction(identifier: "done", title: "Done", options: .foreground)
        let category = UNNotificationCategory(identifier: "category", actions: [remindIn15Mins, remindIn30Mins, done], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        let content = UNMutableNotificationContent()
        content.title = "Pray Title"
        content.subtitle = "Pray Subtitle"
        content.body = "Pray Body"
        content.categoryIdentifier = "category"
        content.sound = UNNotificationSound.default()
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Test", content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            print("Error adding notification request in notification center")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "remindIn15Mins" {
            print("Remind in 15 mins")
        } else if response.actionIdentifier == "remindIn30Mins" {
            print("Remind In 30 mins")
        } else if response.actionIdentifier == "done" {
            print("Done")
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        completionHandler()
    }
    
    
    // MARK: Transition
    func presentSettings() {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        self.present(viewController: settingsViewController, to: .left)
    }
    
    func presentQibla() {
        let storyboard = UIStoryboard(name: "Qibla", bundle: nil)
        let qiblaViewController = storyboard.instantiateViewController(withIdentifier: "Qibla") as! QiblaViewController
        self.present(viewController: qiblaViewController, to: .right)
    }
    
    func present(viewController: UIViewController, to direction: Direction) {
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        transition.type = kCATransitionPush
        
        switch direction {
        case .left:
            transition.subtype = kCATransitionFromLeft
        case .right:
            transition.subtype = kCATransitionFromRight
        }
        
        
        self.navigationController?.view?.layer.add(transition, forKey: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func pop(direction: Direction) {
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        transition.type = kCATransitionPush
        
        switch direction {
        case .left:
            transition.subtype = kCATransitionFromLeft
        case .right:
            transition.subtype = kCATransitionFromRight
        }
        
        self.navigationController?.view?.layer.add(transition, forKey: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: false)
    }
    
    enum Direction {
        case left
        case right
    }

}


