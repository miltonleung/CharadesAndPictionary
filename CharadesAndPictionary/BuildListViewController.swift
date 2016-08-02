//
//  BuildListViewController.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-10.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

protocol BuildListViewControllerDelegate {
    func customCategoryAction(listName: String)
}

class BuildListViewController: UIViewController, UITextFieldDelegate {
    
    var module:AnyObject?
    var moduleName:String?
    
    var delegate:BuildListViewControllerDelegate?
    
    @IBOutlet weak var entryErrorMessage: UILabel!
    
    @IBOutlet weak var buildListView: UIView!
    
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var listDescription: UILabel!
    @IBOutlet weak var listAuthors: UILabel!
    
    @IBOutlet weak var entryCounter: UILabel!
    
    @IBOutlet weak var entryField: UITextField!
    @IBAction func addEntry(sender: AnyObject) {
        addEntrytoList()
        entryField.text = ""
        
    }
    @IBAction func done(sender: AnyObject) {
        if entryField.text?.characters.count > 0 {
            addEntrytoList()
        }
        if isLeader {
            delegate?.customCategoryAction(moduleName!)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func closeView() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppearance()
        updateCount()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.5
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.insertSubview(blurEffectView, atIndex: 0)
        let closeTap = UITapGestureRecognizer(target: self, action: Selector("closeView"))
        view.addGestureRecognizer(closeTap)
        
        listName.text = moduleName
        listDescription.text = module!["description"] as! String
        let authors = module!["author"] as! [String]
        listAuthors.text = "by \(authors[0]) and others"
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func checkForErrorsInput() -> Bool {
        var failed: Bool = false
        if StringUtil.isStringEmpty(entryField.text!) {
            entryErrorMessage.text = ErrorMessages.emptyName
            failed = true
        } else {
            if StringUtil.containsSymbols(entryField.text!) {
                entryErrorMessage.text = ErrorMessages.symbols
                failed = true
            } else {
                entryErrorMessage.text = ""
            }
        }
        
        return failed
        
    }
    
    func updateCount() {
        
        ModelInterface.sharedInstance.fetchListCount(moduleName!, completion: { count -> Void in
            self.entryCounter.text = "\(count)"
        })
        
    }
    
    func addEntrytoList() {
        if !checkForErrorsInput() {
            let listKey = module!["list"] as! String
            ModelInterface.sharedInstance.addToList(listKey, entry: entryField.text!)
            ModelInterface.sharedInstance.addToCount(moduleName!)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func setAppearance() {
        buildListView.layer.cornerRadius = 24
        self.buildListView.layer.borderWidth = 2
        self.buildListView.layer.borderColor = UIColor(red: 82/255.0, green: 82/255.0, blue: 82/255.0, alpha: 1.0).CGColor
        self.buildListView.layer.backgroundColor = UIColor.whiteColor().CGColor
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if entryField.editing {
            entryField.background = UIImage(named: "SmallTextFieldBackgroundDark")
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if entryField.text?.characters.count == 0 {
            entryField.background = UIImage(named: "SmallTextFieldBackground")
        }
        //        tap?.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
