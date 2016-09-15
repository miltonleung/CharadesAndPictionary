//
//  ViewController.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-06-22.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    var ref = FIRDatabaseReference.init()
    var name:String?
    
    var lobbyRoom:String?
    
    @IBOutlet weak var nameError: UIImageView!
    @IBOutlet weak var roomError: UIImageView!
    @IBOutlet weak var passError: UIImageView!
    
    @IBOutlet weak var emojiInputView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var roomField: UITextField!
    @IBAction func submit(sender: AnyObject) {
        submit()
        
    }
    
    @IBOutlet weak var errorMessageTrailing: NSLayoutConstraint!
    @IBOutlet weak var avatar: UIView!
    
    func onClickAvatar() {
        performSegueWithIdentifier("avatarEdit", sender: nil)
    }
    
    func submit() {
        print(roomField.text)
        let editedText = roomField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if !checkForErrorsInput() && passwordField.text != ""  {
            NSUserDefaults.standardUserDefaults().setObject(nameField.text, forKey: "name")
            NSUserDefaults.standardUserDefaults().setObject(roomField.text, forKey: "room")
            NSUserDefaults.standardUserDefaults().setObject(passwordField.text, forKey: "password")
            myName = nameField.text!
            let id = UIDevice.currentDevice().identifierForVendor!.UUIDString
            ModelInterface.sharedInstance.checkForRoom(editedText!, completion: { room -> Void in
                if room.isEmpty {
                    ModelInterface.sharedInstance.addRoom(editedText!, password: self.passwordField.text!)
                    myPlayerKey = ModelInterface.sharedInstance.addPlayer(editedText!, ids: [id])
                    self.lobbyRoom = editedText
                    
                    self.performSegueWithIdentifier("lobbySegue", sender: nil)
                } else {
                    self.lobbyRoom = editedText!
                    guard self.passwordField.text! == room["password"] as! String else {
                        self.passError.hidden = false
                        self.passError.image = UIImage(named: "wrongMessage")
                        return
                    }
                    let id = UIDevice.currentDevice().identifierForVendor!.UUIDString
                    if let players = room["players"] as? [String: AnyObject] {
                        var existingPlayers = [String]()
                        
                        for (_, data) in players {
                            for (name, _) in data as! [String: AnyObject] {
                                existingPlayers.append(name)
                            }
                        }
                        
                        guard !existingPlayers.contains(myName) else {
                            self.nameError.hidden = false
                            self.nameError.image = UIImage(named: "existsMessage")
                            return
                        }
                        if let leader = room["leader"] as? String {
                            if leader == myName {
                                isLeader = true
                            } else {
                                isLeader = false
                            }
                        } else {
                            ModelInterface.sharedInstance.setLeader(editedText!, name: myName)
                        }
                        if var ids = room["ids"] as? [String] {
                            ids.append(id)
                            myPlayerKey = ModelInterface.sharedInstance.addPlayer(editedText!, ids: ids)
                        } else {
                            myPlayerKey = ModelInterface.sharedInstance.addPlayer(editedText!, ids: [id])
                        }
                        self.performSegueWithIdentifier("lobbySegue", sender: nil)
                    } else {
                        if var ids = room["ids"] as? [String] {
                            ids.append(id)
                            myPlayerKey = ModelInterface.sharedInstance.addPlayer(editedText!, ids: ids)
                        } else {
                            myPlayerKey = ModelInterface.sharedInstance.addPlayer(editedText!, ids: [id])
                        }
                        self.lobbyRoom = editedText
                        
                        self.performSegueWithIdentifier("lobbySegue", sender: nil)
                    }
                    
                }
            })
        }
    }
    
    func adjustContraint() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        if screenWidth == 414 {
            errorMessageTrailing.constant = 15
        } else if screenWidth == 375 {
            errorMessageTrailing.constant = 2
        } else if screenWidth < 375 {
            errorMessageTrailing.constant = -11
        }
    }
    
    func checkForErrorsInput() -> Bool {
        var failed: Bool = false
        if StringUtil.isStringEmpty(nameField.text!) {
            nameError.hidden = false
            nameError.image = UIImage(named: "emptyMessage")
            failed = true
        } else {
            if StringUtil.containsSymbols(nameField.text!) {
                nameError.image = UIImage(named: "symbolMessage")
                failed = true
            } else {
                nameError.hidden = true
            }
        }
        if StringUtil.isStringEmpty(roomField.text!) {
            roomError.hidden = false
            roomError.image = UIImage(named: "emptyMessage")
            failed = true
        } else {
            if StringUtil.containsSymbols(roomField.text!) {
                roomError.hidden = false
                roomError.image = UIImage(named: "symbolMessage")
                failed = true
            } else {
                roomError.hidden = true
            }
        }
        if StringUtil.isStringEmpty(passwordField.text!) {
            passError.hidden = false
            passError.image = UIImage(named: "emptyMessage")
        }
        return failed
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = FIRDatabase.database().reference()
        
        nameError.hidden = true
        roomError.hidden = true
        passError.hidden = true
        
        self.view.setWhiteGradientBackground()
        adjustContraint()
        
        avatar.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.83, 0.83);
        let avatarExists = NSUserDefaults.standardUserDefaults().objectForKey("avatarImage")
        if avatarExists == nil {
            let randomAvatar = AvatarUtil.randomAvatar()
            refreshAvatar(AvatarUtil.arrangeAvatar(randomAvatar.0, images: randomAvatar.1))
        } else {
            refreshAvatar(avatarExists as! [String])
        }
        
        let firstRun = NSUserDefaults.standardUserDefaults().boolForKey("firstRun") as Bool
        if !firstRun {
            reset()
        }
        
        setupTextFields()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.onClickAvatar))
        avatar.addGestureRecognizer(gesture)
        
        
        nameField.delegate = self
        
        roomField.delegate = self
        
        if let objects = NSBundle.mainBundle().loadNibNamed("Keyboard", owner: self, options: nil) {
            emojiInputView = objects[0] as! UIView
        }
        passwordField.inputView = emojiInputView
        passwordField.delegate = self
        
    }
    
    func setupTextFields() {
        let nameExists = NSUserDefaults.standardUserDefaults().objectForKey("name")
        if nameExists != nil {
            name = nameExists as? String
            nameField.text = name
        }
        if nameField.text?.characters.count > 0 {
            nameField.background = UIImage(named: "SmallTextFieldBackgroundDark")
        }
        let roomExists = NSUserDefaults.standardUserDefaults().objectForKey("room")
        if roomExists != nil {
            let room = roomExists as? String
            roomField.text = room
        }
        let passExists = NSUserDefaults.standardUserDefaults().objectForKey("password")
        if passExists != nil {
            let pass = passExists as? String
            passwordField.text = pass
        }
        if passwordField.text?.characters.count > 0 {
            passwordField.background = UIImage(named: "TextFieldBackgroundDark")
        }
        if roomField.text?.characters.count > 0 {
            roomField.background = UIImage(named: "TextFieldBackgroundDark")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == nameField { // Switch focus to other text field
            roomField.becomeFirstResponder()
        }
        if textField == roomField { // Switch focus to other text field
            passwordField.becomeFirstResponder()
            
        }
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func keyboardWillShow(notification: NSNotification) {
        if nameField.editing {
            nameField.background = UIImage(named: "SmallTextFieldBackgroundDark")
            if passwordField.text?.characters.count == 0 {
                passwordField.background = UIImage(named: "TextFieldBackground")
            }
            if roomField.text?.characters.count == 0 {
                roomField.background = UIImage(named: "TextFieldBackground")
            }
        } else {
            if roomField.editing {
                roomField.background = UIImage(named: "TextFieldBackgroundDark")
                if passwordField.text?.characters.count == 0 {
                    passwordField.background = UIImage(named: "TextFieldBackground")
                }
                if nameField.text?.characters.count == 0 {
                    nameField.background = UIImage(named: "SmallTextFieldBackground")
                }
            }
            else {
                passwordField.background = UIImage(named: "TextFieldBackgroundDark")
                if roomField.text?.characters.count == 0 {
                    roomField.background = UIImage(named: "TextFieldBackground")
                }
                if nameField.text?.characters.count == 0 {
                    nameField.background = UIImage(named: "SmallTextFieldBackground")
                }
            }
            if self.view.window?.frame.origin.y == 0 {
                self.view.window?.frame.origin.y = -1 * 100
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if roomField.text?.characters.count == 0 {
            roomField.background = UIImage(named: "TextFieldBackground")
        }
        if passwordField.text?.characters.count == 0 {
            passwordField.background = UIImage(named: "TextFieldBackground")
        }
        if self.view.window?.frame.origin.y != 0 {
            self.view.window?.frame.origin.y += 100
        }
    }
    //    func textFieldDidBeginEditing(textField: UITextField) {
    //        passwordField = textField
    //    }
    //    func textFieldDidEndEditing(textField: UITextField) {
    //        passwordField = nil
    //    }
    @IBAction func inputViewButtonPressed(button:UIButton) {
        // Update the text field with the text from the button pressed
        print(passwordField?.text?.characters.count)
        if passwordField?.text?.characters.count > 5 {
            
        } else if passwordField?.text?.characters.count > 0 {
            passwordField?.text = (passwordField?.text)! + (button.titleLabel?.text)!
        } else {
            passwordField?.text = button.titleLabel?.text
        }
        if passwordField.text?.characters.count > 0 {
            passwordField.alpha = 1
        }
    }
    
    @IBAction func deleteText(button:UIButton) {
        if let textField = passwordField, let range = textField.selectedTextRange {
            if range.empty {
                // If the selection is empty, delete the character behind the cursor
                let start = textField.positionFromPosition(range.start, inDirection: .Left, offset: 1)
                let deleteRange = textField.textRangeFromPosition(start!, toPosition: range.end)
                textField.replaceRange(deleteRange!, withText: "")
            }
            else {
                // If the selection isn't empty, delete the chars in the selection
                textField.replaceRange(range, withText: "")
            }
        }
        if passwordField.text?.characters.count == 0 {
            passwordField.background = UIImage(named: "TextFieldBackground")
        }
    }
    
    @IBAction func returnEmoji(sender: AnyObject) {
        passwordField?.resignFirstResponder()
        submit()
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        if textField == nameField {
            return newLength <= 7
        } else {
            return newLength <= 12
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reset() {
        
        ModelInterface.sharedInstance.readCategories( { categories -> Void in
            
            let moviesList = categories["movies"] as? [String]
            NSUserDefaults.standardUserDefaults().setObject(moviesList, forKey: "movies")
            let famousList = categories["famous"] as? [String]
            NSUserDefaults.standardUserDefaults().setObject(famousList, forKey: "famous")
            let celebsList = categories["celebs"] as? [String]
            NSUserDefaults.standardUserDefaults().setObject(celebsList, forKey: "celebs")
            let tvList = categories["tv"] as? [String]
            NSUserDefaults.standardUserDefaults().setObject(tvList, forKey: "tv")
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "lobbySegue") {
            let lobby = segue.destinationViewController as! LobbyViewController
            lobby.roomName = lobbyRoom
        } else if segue.identifier == "avatarEdit" {
            let avatar = segue.destinationViewController as! AvatarViewController
            avatar.delegate = self
        }
        else {
            super.prepareForSegue(segue, sender: sender)
        }
    }
}
protocol RefreshDelegate {
    func refreshAvatar(imageStrings: [String])
}
extension ViewController: RefreshDelegate {
    func refreshAvatar(imageStrings: [String]) {
        avatar.setAvatarView(imageStrings)
        myAvatarImage = imageStrings
        NSUserDefaults.standardUserDefaults().setObject(myAvatarImage, forKey: "avatarImage")
    }
}

