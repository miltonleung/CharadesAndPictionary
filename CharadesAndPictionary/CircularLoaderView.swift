//
//  CircularLoaderView.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-03.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class CircularLoaderView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    let circlePathLayer = CAShapeLayer()
    let circleRadius: CGFloat = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = 3.5
        circlePathLayer.fillColor = UIColor.clearColor().CGColor
        circlePathLayer.strokeColor = UIColor(red: 82/255.0, green: 82/255.0, blue: 82/255.0, alpha: 0.65).CGColor
        layer.addSublayer(circlePathLayer)
        backgroundColor = UIColor.clearColor()
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds) - CGRectGetMidX(circleFrame)
        circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds) - CGRectGetMidY(circleFrame)
        
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        
        return UIBezierPath(ovalInRect: circleFrame())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        let startAngle = -CGFloat(M_PI_2)
        let endAngle = -CGFloat(M_PI_2) + (CGFloat(M_PI) * 2)
        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
        circlePathLayer.path = UIBezierPath(arcCenter:centerPoint, radius: CGRectGetWidth(frame)/2, startAngle:startAngle, endAngle:endAngle, clockwise: true).CGPath
    }
    
    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if (newValue > 1) {
                circlePathLayer.strokeEnd = 1
            } else if (newValue < 0) {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }
}
