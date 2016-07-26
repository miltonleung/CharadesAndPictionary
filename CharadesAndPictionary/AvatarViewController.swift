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
    @IBOutlet weak var previewBox2: UIImageView!
    @IBOutlet weak var previewBox3: UIImageView!
    @IBOutlet weak var previewBox4: UIImageView!
    @IBOutlet weak var previewBox5: UIImageView!
    @IBOutlet weak var previewBox6: UIImageView!
    @IBOutlet weak var previewBox7: UIImageView!
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var skinButton1of3: UIButton!
    @IBOutlet weak var skinButton2: UIButton!
    @IBOutlet weak var skinButton3of3: UIButton!
    @IBOutlet weak var skinButton1of2: UIButton!
    var skin3:[UIButton]?
    var skin2:[UIButton]?
    
    @IBOutlet weak var hairButton1of4: UIButton!
    @IBOutlet weak var hairButton2of4: UIButton!
    @IBOutlet weak var hairButton3of4: UIButton!
    @IBOutlet weak var hairButton4of4: UIButton!
    var hair4:[UIButton]?
    
    @IBOutlet weak var topButton1of4: UIButton!
    @IBOutlet weak var topButton2of4: UIButton!
    @IBOutlet weak var topButton3of4: UIButton!
    @IBOutlet weak var topButton4of4: UIButton!
    var top4:[UIButton]?
    
    @IBOutlet weak var topColor1of3: UIButton!
    @IBOutlet weak var topColorPantsShoes2: UIButton!
    @IBOutlet weak var topColor3of3: UIButton!
    @IBOutlet weak var shorts1of2: UIButton!
    var topColor3:[UIButton]?
    var womenShorts2:[UIButton]?
    
    @IBOutlet weak var shortsShoes1of2: UIButton!
    @IBOutlet weak var shortsShoes2of2: UIButton!
    var maleShortsWomenShoes2:[UIButton]?
    
    @IBOutlet weak var shoes1of4: UIButton!
    @IBOutlet weak var shoes2of4: UIButton!
    @IBOutlet weak var shoes3of4: UIButton!
    @IBOutlet weak var shoes4of4: UIButton!
    var maleShoes4:[UIButton]?
    
    @IBOutlet weak var access1of2: UIButton!
    @IBOutlet weak var access2of2: UIButton!
    var access2:[UIButton]?
    
    @IBOutlet weak var earlyDone: UIButton!
    
    @IBOutlet weak var lineDividerHeight: NSLayoutConstraint!
    
    var avatar = [Int]()
    var selectedChoice:Int?
    var previewBoxes:[UIImageView]?
    
    
    @IBAction func next(sender: UIButton) {
        if selectedChoice != nil {
            if sender.tag == category.gender {
                
                
            } else if sender.tag == category.skinColor {
                
            }
            avatar.insert(selectedChoice!, atIndex: sender.tag)
            let previewBox = previewBoxes![sender.tag + 1]
            setupViews(sender.tag, choice: selectedChoice!, previewBox: previewBox)
            
            selectedChoice = nil
            let offset = flowChartView.contentOffset.y
            self.flowChartView.setContentOffset(CGPoint(x: 0, y: offset + 270.0), animated: true)
        }
    }
    @IBAction func finish(sender: UIButton) {
        if selectedChoice != nil {
        }
    }
    @IBAction func choice(sender: UIButton) {
        selectedChoice = sender.tag
    }
    
    func setupIcons(count: Int, selectButtons: [UIButton], selectIcons:[String], deselectButtons: [UIButton]) {
        for buttons in deselectButtons {
            buttons.hidden = true
        }
        for i in 0...selectButtons.count - 1 {
            selectButtons[i].hidden = false
            selectButtons[i].setImage(UIImage(named: selectIcons[i]), forState: .Normal)
        }
    }
    
    func setupIcons(count: Int, selectButtons: [UIButton], selectIcons:[String]) {
        for i in 0...selectButtons.count - 1 {
            selectButtons[i].hidden = false
            selectButtons[i].setImage(UIImage(named: selectIcons[i]), forState: .Normal)
        }
    }
    
    
    func setupViews(type: Int, choice: Int, previewBox: UIImageView) {
        let gender = avatar.first
        var image:Int?
        switch type {
        case 0:
            switch choice {
            case 0:
                image = 3
                setupIcons(3, selectButtons: skin3!, selectIcons: avatarImages.skinColorMale, deselectButtons: skin2!)
            case 1:
                image = 2
                setupIcons(2, selectButtons: skin2!, selectIcons: avatarImages.skinColorWomen, deselectButtons: skin3!)
            default:
                return
            }
        case 1:
            image = 4
            if gender == 0 {
                setupIcons(4, selectButtons: hair4!, selectIcons: avatarImages.hairMale)
            } else if gender == 1 {
                setupIcons(4, selectButtons: hair4!, selectIcons: avatarImages.hairWomen)
            }
        case 2:
            image = 4
            if gender == 0 {
                setupIcons(4, selectButtons: top4!, selectIcons: avatarImages.topMale)
            } else if gender == 1 {
                setupIcons(4, selectButtons: top4!, selectIcons: avatarImages.topWomen)
            }
        case 3:
            if gender == 0 {
                switch choice {
                case 0,1,2:
                    image = 3
                    setupIcons(3, selectButtons: topColor3!, selectIcons: avatarImages.shoesMaleOutfit, deselectButtons: womenShorts2!)
                case 3:
                    image = 3
                    setupIcons(3, selectButtons: topColor3!, selectIcons: avatarImages.topColor, deselectButtons: womenShorts2!)
                default:
                    return
                }
            } else {
                image = 2
                setupIcons(2, selectButtons: womenShorts2!, selectIcons: avatarImages.pantsWomen, deselectButtons: topColor3!)
            }
        case 4:
            if avatar[category.gender] == 0 {
                if avatar[category.top] < 3 {       // Guy, Outfit, DONE
                    image = 2
                    setupIcons(2, selectButtons: maleShortsWomenShoes2!, selectIcons: avatarImages.accessories)
                    earlyDone.hidden = false
                    lineDividerHeight.constant = 1570
                } else {
                    image = 2                       // Guy, T
                    setupIcons(2, selectButtons: maleShortsWomenShoes2!, selectIcons: avatarImages.pantsMale)
                }
            } else {
                image = 2                           // Girl, DONE
                setupIcons(2, selectButtons: maleShortsWomenShoes2!, selectIcons: avatarImages.shoesWomen)
                earlyDone.hidden = false
                lineDividerHeight.constant = 1570
            }
        case 5:
            image = 4
            setupIcons(2, selectButtons: maleShoes4!, selectIcons: avatarImages.shoesMale)
        case 6:
            image = 2                               // Guy, TShirt, DONE
            setupIcons(2, selectButtons: access2!, selectIcons: avatarImages.accessories)
        default: return
        }
        if image != nil {
            switch image! {
            case 2:
                previewBox.image = UIImage(named: "PreviewBoxTwo")
            case 3:
                previewBox.image = UIImage(named: "PreviewBoxThree")
            case 4:
                previewBox.image = UIImage(named: "PreviewBoxFour")
            default: return
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewBoxes = [previewBox0, previewBox1, previewBox2, previewBox3, previewBox4, previewBox5, previewBox6, previewBox7]
        skin3 = [skinButton1of3, skinButton2, skinButton3of3]
        skin2 = [skinButton1of2, skinButton2]
        hair4 = [hairButton1of4, hairButton2of4, hairButton3of4, hairButton4of4]
        top4 = [topButton1of4, topButton2of4, topButton3of4, topButton4of4]
        topColor3 = [topColor1of3, topColorPantsShoes2, topColor3of3]
        womenShorts2 = [shorts1of2, topColorPantsShoes2]
        maleShortsWomenShoes2 = [shortsShoes1of2, shortsShoes2of2]
        maleShoes4 = [shoes1of4, shoes2of4, shoes3of4, shoes4of4]
        access2 = [access1of2, access2of2]
        
        earlyDone.hidden = true
        
        previewBox4.image = UIImage(named: "PreviewBoxFour")
        
        femaleButton.setImage(UIImage(named: "Female"), forState: .Normal)
        maleButton.setImage(UIImage(named: "Male"), forState: .Normal)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
