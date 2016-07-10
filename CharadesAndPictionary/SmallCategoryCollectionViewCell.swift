//
//  SmallCategoryCollectionViewCell.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-09.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class SmallCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            if newValue {
                super.selected = true
                if isPrivate {
                    self.layer.backgroundColor = UIColor(patternImage: UIImage(named: "DefaultSmallIconSelectedDark")!).CGColor
                } else {
                    self.layer.backgroundColor = UIColor(patternImage: UIImage(named: "DefaultSmallIconSelected")!).CGColor
                }
            } else if newValue == false {
                super.selected = false
                if isPrivate {
                    self.layer.backgroundColor = UIColor(patternImage: UIImage(named: "DefaultSmallIconDark")!).CGColor
                } else {
                    self.layer.backgroundColor = UIColor(patternImage: UIImage(named: "DefaultSmallIcon")!).CGColor
                }
            }
        }
    }
}
