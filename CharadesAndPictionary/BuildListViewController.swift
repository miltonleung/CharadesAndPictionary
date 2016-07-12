//
//  BuildListViewController.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-10.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class BuildListViewController: UIViewController, UITextFieldDelegate {
    
    var module:AnyObject?
    var moduleName:String?
    
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppearance()
        updateCount()
        
        listName.text = moduleName
        listDescription.text = module!["description"] as! String
        let authors = module!["author"] as! [String]
        listAuthors.text = "by \(authors[0]) and others"
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func updateCount() {
        
        ModelInterface.sharedInstance.fetchListCount(moduleName!, completion: { count -> Void in
            self.entryCounter.text = "\(count)"
        })
        
    }
    
    func addEntrytoList() {
        let listKey = module!["list"] as! String
        ModelInterface.sharedInstance.addToList(listKey, entry: entryField.text!)
        ModelInterface.sharedInstance.addToCount(moduleName!)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func setAppearance() {
        buildListView.layer.cornerRadius = 24
        self.buildListView.layer.borderWidth = 2
        self.buildListView.layer.borderColor = UIColor(red: 214/255.0, green: 214/255.0, blue: 214/255.0, alpha: 1.0).CGColor
        self.buildListView.layer.backgroundColor = UIColor(red: 225/255.0, green: 243/255.0, blue: 247/255.0, alpha: 1.0).CGColor
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
