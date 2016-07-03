//
//  ViewController.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-06-22.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit
import Kanna
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    var ref = FIRDatabaseReference.init()
    var name:String?
    
    var lobbyRoom:String?
    
    
    @IBOutlet weak var emojiInputView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var roomField: UITextField!
    @IBAction func submit(sender: AnyObject) {
        submit()
        
    }
    
    func submit() {
        print(roomField.text)
        let editedText = roomField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if editedText != "" && passwordField.text != "" && nameField != "" {
            NSUserDefaults.standardUserDefaults().setObject(nameField.text, forKey: "name")
            NSUserDefaults.standardUserDefaults().setObject(roomField.text, forKey: "room")
            NSUserDefaults.standardUserDefaults().setObject(passwordField.text, forKey: "password")
            myName = nameField.text!
            checkForRoom({ room -> Void in
                if self.isAvailable(editedText!, room: room) {
                    self.addRoom(editedText!)
                    isLeader = true
                    
                    self.performSegueWithIdentifier("lobbySegue", sender: nil)
                } else {
                    let attributes = room[editedText!] as! [String: AnyObject]
                    self.lobbyRoom = editedText!
                    if self.passwordField.text! == attributes["password"] as! String {
                        
                        var existingPlayers = attributes["players"] as! [String]
                        if !existingPlayers.contains(myName) {
                            existingPlayers.append(myName)
                            if existingPlayers[1] == myName {
                                isLeader = true
                            }
                            self.ref.child("rooms/\(editedText!)/players").setValue(existingPlayers)
                            
                            let playerUpdates = ["rooms/\(editedText!)/scores/\(self.nameField.text!)/": ["Threat Level Midnight"]]
                            isLeader = false
                            self.ref.updateChildValues(playerUpdates)
                            self.performSegueWithIdentifier("lobbySegue", sender: nil)
                        } else {
                            print("A player with the same name already exists")
                        }
                        
                        
                    }
                }
            })
        }
    }
    
    func addRoom(editedText: String) {
        self.lobbyRoom = editedText
        self.ref.child("rooms/\(editedText)/password").setValue(self.passwordField.text!)
        self.ref.child("rooms/\(editedText)/ready").setValue(["Michael Scott"])
        self.ref.child("rooms/\(editedText)/players").setValue(["Michael Scott", "\(myName)"])
        self.ref.child("rooms/\(editedText)/done").setValue([-1])
        self.ref.child("rooms/\(editedText)/category").setValue(" ")
        self.ref.child("rooms/\(editedText)/currentSelection").setValue(-1)
        self.ref.child("rooms/\(editedText)/currentPlayer").setValue("\(myName)")
        self.ref.child("rooms/\(editedText)/startTime").setValue("\(0)")
        let myPlayer:[String: AnyObject] = ["\(self.nameField.text!)": ["Threat Level Midnight"]]
        self.ref.child("rooms/\(editedText)/scores").setValue(myPlayer)
    }
    
    func addFillerRoom() {
        self.ref.child("rooms/capfill/password").setValue("123")
    }
    
    func isAvailable(roomName :String, room: [String: AnyObject]) -> Bool {
        if room.isEmpty {
            return true
        }
        else {
            for (existingName, _) in room {
                if existingName == roomName {
                    return false
                }
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = FIRDatabase.database().reference()
        
        let firstRun = NSUserDefaults.standardUserDefaults().boolForKey("firstRun") as Bool
        if !firstRun {
            reset()
        }
        
        setupTextFields()
        
        addFillerRoom()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        nameField.delegate = self
        
        roomField.delegate = self
        
        if let objects = NSBundle.mainBundle().loadNibNamed("Keyboard", owner: self, options: nil) {
            emojiInputView = objects[0] as! UIView
        }
        passwordField.inputView = emojiInputView
        passwordField.delegate = self
        //        passwordField.becomeFirstResponder(
        
    }
    
    func setupTextFields() {
        let nameExists = NSUserDefaults.standardUserDefaults().objectForKey("name")
        if nameExists != nil {
            name = nameExists as? String
            nameField.text = name
        }
        if nameField.text?.characters.count > 0 {
            nameField.background = UIImage(named: "SmallTextFieldBackgroundWhite")
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
            passwordField.background = UIImage(named: "TextFieldBackgroundWhite")
        }
        if roomField.text?.characters.count > 0 {
            roomField.background = UIImage(named: "TextFieldBackgroundWhite")
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
            nameField.background = UIImage(named: "SmallTextFieldBackgroundWhite")
            if passwordField.text?.characters.count == 0 {
                passwordField.background = UIImage(named: "TextFieldBackground")
            }
            if roomField.text?.characters.count == 0 {
                roomField.background = UIImage(named: "TextFieldBackground")
            }
        } else {
            if roomField.editing {
                roomField.background = UIImage(named: "TextFieldBackgroundWhite")
                if passwordField.text?.characters.count == 0 {
                    passwordField.background = UIImage(named: "TextFieldBackground")
                }
                if nameField.text?.characters.count == 0 {
                    nameField.background = UIImage(named: "SmallTextFieldBackground")
                }
            }
            else {
                passwordField.background = UIImage(named: "TextFieldBackgroundWhite")
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
        if let textField = passwordField, range = textField.selectedTextRange {
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
        let moviesRef = ref.child("modules/public/movies")
        moviesRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let moviesList = snapshot.value as! [String]
            NSUserDefaults.standardUserDefaults().setObject(moviesList, forKey: "movies")
            
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "lobbySegue") {
            let lobby = segue.destinationViewController as! LobbyViewController
            lobby.roomName = lobbyRoom
        }
        else {
            super.prepareForSegue(segue, sender: sender)
        }
    }
    
    func checkForRoom(completion: [String: AnyObject] -> Void) {
        let roomPath = self.ref.child("rooms")
        roomPath.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            let roomData = snapshot.value as! [String: AnyObject]
            print(snapshot.value)
            completion(roomData)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    var listMovies = [String]()
    func fetchMovies() {
        for i in 1...7 {
            fetchPage("http://www.boxofficemojo.com/alltime/world/?pagenum=\(i)&p=.htm")
        }
        self.ref.child("modules/public/movies").setValue(listMovies)
    }
    
    func fetchPage(URL: String) {
        guard let pageURL = NSURL(string: URL) else {
            print("Error: \(URL) doesn't seem to be a valid URL")
            return
        }
        var pageHTML:String?
        do {
            pageHTML = try String(contentsOfURL: pageURL, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print("Error: \(error)")
        }
        
        if let doc = Kanna.HTML(html: pageHTML!, encoding: NSUTF8StringEncoding) {
            for link in doc.xpath("//a[starts-with(@href,'/movies/?id=')]/b") {
                listMovies.append(link.text!)
                
            }
        }
    }
    
    
}

