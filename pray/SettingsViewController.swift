//
//  SettingsViewController.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/23/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit

class SettingsViewController: PrayViewController {

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var backgroundImagePattern: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var subview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location.text = DataSource.currentPlacemark.locality
        setupSwipeGesture()
        subview.layer.cornerRadius = 10.0
        subview.clipsToBounds = true
        backgroundImagePattern.imageGradientFadeTop(target: self)
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func setupSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        self.pop(direction: .right)
    }

}
