//
//  AvatarViewController.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-24.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class AvatarViewController: UIViewController {
    
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var flowChartView: UIScrollView!
    
    @IBOutlet weak var previewBox0: UIImageView!
    @IBOutlet weak var previewBox1: UIImageView!
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var skinButton1of3: UIButton!
    @IBOutlet weak var skinButton2: UIButton!
    @IBOutlet weak var skinButton3of3: UIButton!
    @IBOutlet weak var skinButton1of2: UIButton!
    var skin3:[UIButton]?
    var skin2:[UIButton]?
    
    var avatar = [Int]()
    var selectedChoice:Int?
    var previewBoxes:[UIImageView]?
    
    
    @IBAction func next(sender: UIButton) {
        if selectedChoice != nil {
            if sender.tag == category.gender {
                avatar.insert(selectedChoice!, atIndex: sender.tag)
                let previewBox = previewBoxes![sender.tag + 1]
                setupViews(sender.tag, choice: selectedChoice!, previewBox: previewBox)
                
            } else if sender.tag == category.skinColor {
                
            }
            selectedChoice = nil
            let offset = flowChartView.contentOffset.y
            self.flowChartView.setContentOffset(CGPoint(x: 0, y: offset + 315.0), animated: true)
        }
    }
    @IBAction func choice(sender: UIButton) {
        selectedChoice = sender.tag
    }
    
    func setupIcons(count: Int, selectButtons: [UIButton], selectIcons:[String], deselectButtons: [UIButton]) {
        for buttons in deselectButtons {
            buttons.hidden = true
        }
        for i in 0...(skin3?.count)! - 1 {
            selectButtons[i].hidden = false
            selectButtons[i].setImage(UIImage(named: selectIcons[i]), forState: .Normal)
        }
        
    }
    
    func setupViews(type: Int, choice: Int, previewBox: UIImageView) {
        var image:String = ""
        switch type {
        case 0:
            switch choice {
            case 0:
                image = "PreviewBoxThree"
                setupIcons(3, selectButtons: skin3!, selectIcons: avatarImages.skinColorMale, deselectButtons: skin2!)
            case 1:
                image = "PreviewBoxTwo"
            default:
                break
            }
        case 1, 2:
            image = "PreviewBoxFour"
        case 3:
            if avatar[category.gender] == 0 {
                switch choice {
                case 1,2,3:
                    image = "PreviewBoxThree"
                case 4:
                    image = "PreviewBoxThree"
                default:
                    break
                }
            } else {
                image = "PreviewBoxTwo"
            }
        case 4:
            if avatar[category.gender] == 0 {
                if avatar[category.top] < 3 {       // Chose Outfit
                    image = "PreviewBoxTwo"
                } else {
                    image = "PreviewBoxTwo"          // Guy, Outfit, DONE
                }
            } else {
                image = "PreviewBoxTwo"              // Girl, DONE
            }
        case 5:
            image = "PreviewBoxFour"
        case 6:
            image = "PreviewBoxTwo"                  // Guy, TShirt, DONE
        default: break
        }
        if image != "" {
            previewBox.image = UIImage(named: "\(image)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewBoxes = [previewBox0, previewBox1]
        skin3 = [skinButton1of3, skinButton2, skinButton3of3]
        skin2 = [skinButton1of2, skinButton2]
        
        femaleButton.setImage(UIImage(named: "Female"), forState: .Normal)
        maleButton.setImage(UIImage(named: "Male"), forState: .Normal)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
