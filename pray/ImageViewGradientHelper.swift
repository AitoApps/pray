//
//  ImageViewGradientHelper.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/23/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func imageGradientFadeTop(target: UIViewController) {
        let mask = CAGradientLayer()
        mask.startPoint = CGPoint(x: 1.0, y: 0.1)
        mask.endPoint = CGPoint(x:1.0, y:1.0)
        let whiteColor = UIColor.white
        mask.colors = [whiteColor.withAlphaComponent(1.0).cgColor, whiteColor.withAlphaComponent(1.0),whiteColor.withAlphaComponent(1.0).cgColor]
        mask.locations = [NSNumber(value: 0.0), NSNumber(value: 0.0)]
        mask.frame = CGRect(x: 0, y: target.view.frame.height - 2 * (target.view.frame.width), width: target.view.frame.width, height: 2 * target.view.frame.width)
        self.layer.mask = mask
    }
}
