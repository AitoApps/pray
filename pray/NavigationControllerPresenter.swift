//
//  NavigationControllerPresenter.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/24/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    /*
    func present(viewController: UIViewController, direction: Direction, target: UIViewController) {
        viewController.navigationController?.isNavigationBarHidden = false
        
        if let navigationController = viewController.navigationController {
            navigationController.isNavigationBarHidden = true
        }
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        transition.type = kCATransitionPush
        
        if direction == .Left {
            transition.subtype = kCATransitionFromLeft
        } else if direction == .Right {
            transition.subtype = kCATransitionFromRight
        }
        
        transition.delegate = target
        target.view?.layer.add(transition, forKey: nil)
        self.pushViewController(viewController, animated: false)
    }
    
    enum Direction {
        case Left
        case Right
    }
 */
}
