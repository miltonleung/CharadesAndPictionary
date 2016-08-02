//
//  ViewUtil.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-08-02.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    func setWhiteGradientBackground() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        if screenWidth == 414 {
            self.backgroundColor = UIColor(patternImage: UIImage(named: "WhiteGradient6Plus")!)
        } else if screenWidth == 375 {
            self.backgroundColor = UIColor(patternImage: UIImage(named: "WhiteGradient")!)
            
        } else if screenWidth < 375 {
            self.backgroundColor = UIColor(patternImage: UIImage(named: "WhiteGradient5")!)
        }
    }
}