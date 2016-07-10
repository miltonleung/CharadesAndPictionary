//
//  NewListViewController.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-08.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class NewListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var newListView: UIView!
    @IBOutlet weak var buildAList: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var listName: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var nameFieldLabel: UILabel!
    @IBOutlet weak var descriptionFieldLabel: UILabel!
    
    var selectedIcon:String?
    var selectedIndex: NSIndexPath?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var create: UIButton!
    @IBAction func create(sender: AnyObject) {
        createAction()
    }
    
    var players:[String]?
    
    func createAction() {
        var publicOrPrivate:String?
        if isPrivate == false {
            publicOrPrivate = "public"
        } else {
            publicOrPrivate = "private"
        }
        ModelInterface.sharedInstance.makeRoom(listName.text!, authors: players!, icon: selectedIcon!, description: descriptionField.text!, publicOrPrivate: publicOrPrivate!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var cancel: UIButton!
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var privateButton: UIButton!
    @IBAction func `private`(sender: AnyObject) {
        if isPrivate == false {
            isPrivate = true
            darkState()
            
        } else {
            isPrivate = false
            lightState()
        }
        collectionView.reloadData()
    }
    
    func darkState() {
        self.newListView.layer.borderColor = UIColor(red: 94/255.0, green: 94/255.0, blue: 94/255.0, alpha: 1.0).CGColor
        self.newListView.layer.backgroundColor = UIColor(red: 92/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1.0).CGColor
        buildAList.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.85)
        status.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.85)
        status.text = "(private)"
        create.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.71), forState: .Normal)
        cancel.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.71), forState: .Normal)
        listName.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.85)
        descriptionField.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.85)
        nameFieldLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.85)
        descriptionFieldLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.85)
        
        if listName.text?.characters.count == 0 {
            listName.background = UIImage(named: "SmallTextFieldBackground")
        } else {
            listName.background = UIImage(named: "SmallTextFieldBackgroundWhite")
        }
        if descriptionField.text?.characters.count == 0 {
            descriptionField.background = UIImage(named: "SmallTextFieldBackground")
        } else {
            descriptionField.background = UIImage(named: "SmallTextFieldBackgroundWhite")
        }
    }
    var tap: UITapGestureRecognizer?
    func lightState() {
        newListView.layer.cornerRadius = 24
        self.newListView.layer.borderWidth = 2
        self.newListView.layer.borderColor = UIColor(red: 214/255.0, green: 214/255.0, blue: 214/255.0, alpha: 1.0).CGColor
        self.newListView.layer.backgroundColor = UIColor(red: 225/255.0, green: 243/255.0, blue: 247/255.0, alpha: 1.0).CGColor
        buildAList.textColor = UIColor(red: 104/255.0, green: 104/255.0, blue: 104/255.0, alpha: 0.85)
        status.textColor = UIColor(red: 104/255.0, green: 104/255.0, blue: 104/255.0, alpha: 0.85)
        status.text = "(public)"
        privateButton.setBackgroundImage(UIImage(named: "Private"), forState: .Normal)
        create.setTitleColor(UIColor(red: 104/255.0, green: 104/255.0, blue: 104/255.0, alpha: 0.71), forState: .Normal)
        cancel.setTitleColor(UIColor(red: 104/255.0, green: 104/255.0, blue: 104/255.0, alpha: 0.71), forState: .Normal)
        listName.textColor = UIColor(red: 121/255.0, green: 124/255.0, blue: 124/255.0, alpha: 1.0)
        descriptionField.textColor = UIColor(red: 121/255.0, green: 124/255.0, blue: 124/255.0, alpha: 1.0)
        nameFieldLabel.textColor = UIColor(red: 121/255.0, green: 124/255.0, blue: 124/255.0, alpha: 1.0)
        descriptionFieldLabel.textColor = UIColor(red: 121/255.0, green: 124/255.0, blue: 124/255.0, alpha: 1.0)
        
        if listName.text?.characters.count == 0 {
            listName.background = UIImage(named: "SmallTextFieldBackground")
        } else {
            listName.background = UIImage(named: "SmallTextFieldBackgroundDark")
        }
        if descriptionField.text?.characters.count == 0 {
            descriptionField.background = UIImage(named: "SmallTextFieldBackground")
        } else {
            descriptionField.background = UIImage(named: "SmallTextFieldBackgroundDark")
        }
    }
    
    override func viewDidLoad() {
        collectionView.allowsSelection = true
        
        super.viewDidLoad()
        
        lightState()
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap!)
        tap?.enabled = false
        
        listName.delegate = self
        descriptionField.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func keyboardWillShow(notification: NSNotification) {
        var dark = ""
        if isPrivate == true {
            dark = "White"
        } else {
            dark = "Dark"
        }
        if listName.editing {
            listName.background = UIImage(named: "SmallTextFieldBackground\(dark)")
            if descriptionField.text?.characters.count == 0 {
                descriptionField.background = UIImage(named: "SmallTextFieldBackground")
            }
        } else if descriptionField.editing {
            descriptionField.background = UIImage(named: "SmallTextFieldBackground\(dark)")
            if listName.text?.characters.count == 0 {
                listName.background = UIImage(named: "SmallTextFieldBackground")
            }
        }
        tap?.enabled = true
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if listName.text?.characters.count == 0 {
            listName.background = UIImage(named: "SmallTextFieldBackground")
        }
        if descriptionField.text?.characters.count == 0 {
            descriptionField.background = UIImage(named: "SmallTextFieldBackground")
        }
        tap?.enabled = false
    }
    
    let reuseIdentifier = "smallCell"
    var items = ["Famous", "Mic", "Play", "Thumbtack"]
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SmallCategoryCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.image.image = UIImage(named: "\(self.items[indexPath.item])Small")
        cell.backgroundColor = UIColor.clearColor() // make cell more visible in our example project
        
        if isPrivate == true {
            if self.items[indexPath.item] == selectedIcon {
                cell.selected = true
                cell.backgroundColor = UIColor(patternImage: UIImage(named: "DefaultSmallIconSelectedDark")!)
                
            } else {
                cell.backgroundColor = UIColor(patternImage: UIImage(named: "DefaultSmallIconDark")!)
            }
        } else {
            if self.items[indexPath.item] == selectedIcon {
                cell.selected = true
                cell.backgroundColor = UIColor(patternImage: UIImage(named: "DefaultSmallIconSelected")!)
            } else {
                cell.backgroundColor = UIColor(patternImage: UIImage(named: "DefaultSmallIcon")!)
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        if selectedIndex != nil {
            let cell = collectionView.cellForItemAtIndexPath(selectedIndex!)
            if isPrivate == true {
                cell!.backgroundColor = UIColor(patternImage: UIImage(named: "DefaultSmallIconDark")!)
            } else {
                cell!.backgroundColor = UIColor(patternImage: UIImage(named: "DefaultSmallIcon")!)
            }
        }
        selectedIcon = self.items[indexPath.item]
        selectedIndex = indexPath
        
    }
}
extension NewListViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        if textField == listName {
            return newLength <= 9
        } else {
            return newLength <= 19
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == listName { // Switch focus to other text field
            descriptionField.becomeFirstResponder()
        }
        if textField == descriptionField { // Switch focus to other text field
            createAction()
        }
        return true
    }
}
