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
    
    @IBOutlet weak var shoes1of2: UIButton!
    @IBOutlet weak var shoes2of2: UIButton!
    var maleShoes2:[UIButton]?
    
    @IBOutlet weak var access1of2: UIButton!
    @IBOutlet weak var access2of2: UIButton!
    var access2:[UIButton]?
    
    @IBOutlet weak var previewImage0: UIView!
    @IBOutlet weak var previewImage1: UIView!
    @IBOutlet weak var previewImage2: UIView!
    @IBOutlet weak var previewImage3: UIView!
    @IBOutlet weak var previewImage4: UIView!
    @IBOutlet weak var previewImage5: UIView!
    @IBOutlet weak var previewImage6: UIView!
    @IBOutlet weak var previewImage7: UIView!
    var previewImages:[UIView]?
    
    
    @IBOutlet weak var earlyDone: UIButton!
    @IBOutlet weak var earlyEarlyDone: UIButton!
    
    @IBOutlet weak var lineDividerHeight: NSLayoutConstraint!
    
    var avatar = [Int]()
    var selectedChoice:Int?
    var previewBoxes:[UIImageView]?
    
    var buttonSelect:[Int: Bool] = [0: false, 1: false, 2: false, 3: false, 4: false, 5: false, 6: false]
    
    var section:Int = 0
    
    var delegate:RefreshDelegate?
    var avatarImage:[String]?
    
    
    @IBAction func next(sender: UIButton) {
        if buttonSelect[sender.tag] == true {
            let offset = flowChartView.contentOffset.y
            hideDone()
            section -= 1
            setAvatar()
            
            self.flowChartView.setContentOffset(CGPoint(x: 0, y: offset - 274.0), animated: true)
            UIView.animateWithDuration(0.5) { () -> Void in
                sender.imageView?.transform = CGAffineTransformMakeRotation(0)
                
            }
            selectedChoice = avatar.last
            
            buttonSelect[sender.tag] = false
        } else {
            if selectedChoice == nil {
                avatar.insert(0, atIndex: section)
                selectedChoice = 0
                madeAChoice()
            }
            
            let previewBox = previewBoxes![sender.tag + 1]
            setupViews(sender.tag, choice: selectedChoice!, previewBox: previewBox)
            
            
            
            let offset = flowChartView.contentOffset.y
            self.flowChartView.setContentOffset(CGPoint(x: 0, y: offset + 274.0), animated: true)
            
            buttonSelect[sender.tag] = true
            
            section += 1
            if section < avatar.count {
                
                selectedChoice = avatar[section]
            } else {
                selectedChoice = nil
            }
            
            UIView.animateWithDuration(0.5) { () -> Void in
                sender.imageView?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                
            }
        }
    }
    @IBAction func finish(sender: UIButton) {
        if selectedChoice != nil || avatar.first == 0 {
            delegate?.refreshAvatar(avatarImage!)
            dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    @IBAction func choice(sender: UIButton) {
        selectedChoice = sender.tag
        madeAChoice()
        
    }
    func madeAChoice() {
        for previewImage in previewImages![section].subviews {
            previewImage.removeFromSuperview()
        }
        if section < 7 {
            for previewImage in previewImages![section + 1].subviews {
                previewImage.removeFromSuperview()
            }
        }
        if avatar.indices.contains(section) {
            avatar[section] = selectedChoice!
        } else {
            avatar.insert(selectedChoice!, atIndex: section)
        }
        setAvatar()
    }
    func setAvatar() {
        for previewImage in previewImages![section].subviews {
            previewImage.removeFromSuperview()
        }
        
        var imageStrings = buildAvatar()
        if avatarPath! == womenTPath {
            imageStrings.append(imageStrings.removeAtIndex(3))
            imageStrings.append(imageStrings.removeAtIndex(0))
            
        } else if avatarPath! == womenOutfitPath {
            imageStrings.append(imageStrings.removeAtIndex(0))
        } else if avatarPath! == maleTPath {
            imageStrings.append(imageStrings.removeAtIndex(5))
            imageStrings.append(imageStrings.removeAtIndex(0))
            if imageStrings.count >= 7 {
                if (avatar[avatarType.hair] == 0 || avatar[avatarType.hair] == 3) && imageStrings.contains(avatarImages.accessories[0]){
                    imageStrings.removeAtIndex(2)
                }
            }
        } else if avatarPath! == maleOutfitPath {
            imageStrings.append(imageStrings.removeAtIndex(1))
            imageStrings.append(imageStrings.removeAtIndex(2))
            if imageStrings.count == 7 {
                if (avatar[avatarType.hair] == 0 || avatar[avatarType.hair] == 3) && imageStrings.contains(avatarImages.accessories[0]){
                    imageStrings.removeLast()
                }
                imageStrings.append(imageStrings.removeAtIndex(4))
                
            }
            imageStrings.append(imageStrings.removeAtIndex(0))
            
        }
        avatarImage = imageStrings
        for image in imageStrings {
            previewImages![section].addSubview(UIImageView(image: UIImage(named: "\(image)Small")))
            if section < 7 {
                previewImages![section + 1].addSubview(UIImageView(image: UIImage(named: "\(image)Small")))
            }
        }
    }
    
    var avatarPath:[[String]]?
    func buildAvatar() -> [String] {
        var imageStrings = [String]()
        if avatar.first == 0 {
            avatarPath = maleOutfitPath
            if avatar.count >= 4 {
                if avatar[3] == 2 {
                    avatarPath = maleTPath
                }
            }
        } else {
            avatarPath = womenOutfitPath
            if avatar.count >= 4 {
                if avatar[3] == 1 || avatar[3] == 2 {
                    avatarPath = womenTPath
                }
            }
        }
        
        for i in 0...avatar.count - 1 {
            let selectedItem = avatar[i]
            
            if i == 1  && avatar.first == 0 {
                imageStrings.append(avatarImages.headMale[selectedItem])
            }
            if i == 0 {
                for image in avatarPath![i] {
                    imageStrings.append(image)
                }
            } else {
                let imageString = avatarPath![i][selectedItem]
                imageStrings.append(imageString)
            }
        }
        if avatar.count < avatarPath!.count {
            for i in avatar.count...(avatarPath?.count)! - 1 {
                if avatar.first == 0 && i == 1 {
                    let imageString = avatarImages.headMale.first
                    imageStrings.append(imageString!)
                }
                if avatar.first != 0 || i != (avatarPath?.count)! - 1 {
                    let imageString = avatarPath![i].first
                    imageStrings.append(imageString!)
                }
            }
        }
        return imageStrings
    }
    
    func setupIcons(count: Int, selectButtons: [UIButton], selectIcons:[String], deselectButtons: [UIButton]) {
        for buttons in deselectButtons {
            buttons.hidden = true
        }
        for i in 0...selectButtons.count - 1 {
            selectButtons[i].hidden = false
            selectButtons[i].setImage(UIImage(named: "\(selectIcons[i])Icon"), forState: .Normal)
        }
    }
    
    func setupIcons(count: Int, selectButtons: [UIButton], selectIcons:[String]) {
        for i in 0...selectButtons.count - 1 {
            selectButtons[i].hidden = false
            selectButtons[i].setImage(UIImage(named: "\(selectIcons[i])Icon"), forState: .Normal)
        }
    }
    
    func hideDone() {
        earlyDone.hidden = true
        earlyEarlyDone.hidden = true
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
                case 0,1,3:
                    image = 3
                    setupIcons(3, selectButtons: topColor3!, selectIcons: avatarImages.shoesMaleOutfit, deselectButtons: womenShorts2!)
                case 2:
                    image = 3
                    setupIcons(3, selectButtons: topColor3!, selectIcons: avatarImages.topColor, deselectButtons: womenShorts2!)
                default:
                    return
                }
            } else {
                image = 2
                switch choice {
                case 0, 3:
                    setupIcons(2, selectButtons: womenShorts2!, selectIcons: avatarImages.shoesWomen, deselectButtons: topColor3!)
                    earlyEarlyDone.hidden = false
                    lineDividerHeight.constant = 1233
                case 1, 2:
                    setupIcons(2, selectButtons: womenShorts2!, selectIcons: avatarImages.pantsWomen, deselectButtons: topColor3!)
                default:
                    return
                }
            }
        case 4:
            if avatar[avatarType.gender] == 0 {
                if avatar[avatarType.top] != 2 {       // Guy, Outfit, DONE
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
            image = 2
            setupIcons(2, selectButtons: maleShoes2!, selectIcons: avatarImages.shoesMale)
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
        
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor(red: 92/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1).CGColor
        avatarView.layer.cornerRadius = 20
        
        previewBoxes = [previewBox0, previewBox1, previewBox2, previewBox3, previewBox4, previewBox5, previewBox6, previewBox7]
        previewImages = [previewImage0, previewImage1, previewImage2, previewImage3, previewImage4, previewImage5, previewImage6, previewImage7]
        skin3 = [skinButton1of3, skinButton2, skinButton3of3]
        skin2 = [skinButton1of2, skinButton2]
        hair4 = [hairButton1of4, hairButton2of4, hairButton3of4, hairButton4of4]
        top4 = [topButton1of4, topButton2of4, topButton3of4, topButton4of4]
        topColor3 = [topColor1of3, topColorPantsShoes2, topColor3of3]
        womenShorts2 = [shorts1of2, topColorPantsShoes2]
        maleShortsWomenShoes2 = [shortsShoes1of2, shortsShoes2of2]
        maleShoes2 = [shoes1of2, shoes2of2]
        access2 = [access1of2, access2of2]
        
        hideDone()
        
        femaleButton.setImage(UIImage(named: "Female"), forState: .Normal)
        maleButton.setImage(UIImage(named: "Male"), forState: .Normal)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
