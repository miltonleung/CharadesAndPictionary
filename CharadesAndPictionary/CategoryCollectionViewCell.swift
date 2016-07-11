//
//  CategoryCollectionViewCell.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-07.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            if isLeader {
                if newValue {
                    super.selected = true
                    self.layer.backgroundColor = UIColor(patternImage: UIImage(named: "Selected")!).CGColor
                } else if newValue == false {
                    super.selected = false
                    self.layer.backgroundColor = UIColor.clearColor().CGColor
                }
            }
        }
    }
}
