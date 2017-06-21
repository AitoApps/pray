//
//  LoadingView.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/21/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
