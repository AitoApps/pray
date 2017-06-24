//
//  InitialViewController.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/21/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit

class InitialViewController: UIViewController {

    @IBOutlet weak var backgroundPatternImageView: UIImageView!
    
    
    var loadingView = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundPatternImageView.imageGradientFadeTop(target: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if hasPlacemark() {
            preloadDaysFromCoreData()
            if DataSource.calendar.count == 0 {
                getCalendarFromAPIToCoreData(placemark: DataSource.currentPlacemark, completion: {
                    self.presentMain()
                })
            } else {
                self.presentMain()
            }
            
        }
    }
    
    func hasPlacemark() -> Bool {
        
        if let placemarkData  = UserDefaults.standard.object(forKey: "placemark") as? Data {
            let placemark = NSKeyedUnarchiver.unarchiveObject(with: placemarkData) as! CLPlacemark
            DataSource.currentPlacemark = placemark
            return true
        } else {
            return false
        }
    }
    
    func presentMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        self.present(main, animated: false, completion: nil)
    }
    
    
}

