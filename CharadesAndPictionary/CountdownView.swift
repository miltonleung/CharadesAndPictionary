//
//  CountdownView.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-03.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class CountdownView: UIView {

    let progressIndicatorView = CircularLoaderView(frame: CGRectZero)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(self.progressIndicatorView)
        progressIndicatorView.frame = bounds
        progressIndicatorView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProgress", name: "timeChange", object: nil)

    
    
    }
    
    func updateProgress() {
        self.progressIndicatorView.progress = CGFloat(countDownTime)/CGFloat(8)

    }
    

}
