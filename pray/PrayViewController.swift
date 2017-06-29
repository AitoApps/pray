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


