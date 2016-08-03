//
//  ViewController.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-06-22.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit
//import Kanna
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
            ModelInterface.sharedInstance.checkForRoom({ room -> Void in
                if self.isAvailable(editedText!, room: room) {
                    ModelInterface.sharedInstance.addRoom(editedText!, password: self.passwordField.text!)
                    ModelInterface.sharedInstance.addPlayer(editedText!)
                    self.lobbyRoom = editedText
                    isLeader = true
                    
                    self.performSegueWithIdentifier("lobbySegue", sender: nil)
                } else {
                    let attributes = room[editedText!] as! [String: AnyObject]
                    self.lobbyRoom = editedText!
                    if self.passwordField.text! == attributes["password"] as! String {
                        
                        let playersData = attributes["players"] as! [String: [String]]
                        var existingPlayers = [String]()
                        for (name, _) in playersData {
                            existingPlayers.append(name)
                        }
                        if !existingPlayers.contains(myName) {
                            existingPlayers.append(myName)
                            if existingPlayers.count == 1 {
                                isLeader = true
                            }
                            ModelInterface.sharedInstance.addPlayer(editedText!)
                            isLeader = false
                            self.performSegueWithIdentifier("lobbySegue", sender: nil)
                        } else {
                            self.nameError.hidden = false
                            self.nameError.image = UIImage(named: "existsMessage")
                            
                        }
                    } else {
                        self.passError.hidden = false
                        self.passError.image = UIImage(named: "wrongMessage")
                    }
                }
            })
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
        
        nameError.hidden = true
        roomError.hidden = true
        passError.hidden = true
        
        self.view.setWhiteGradientBackground()
        
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let gesture = UITapGestureRecognizer(target: self, action: Selector("onClickAvatar"))
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

    
    
    
//    var listFamous = [String]()
//    func fetchFamous() {
//        fetchFamousPage("https://www.randomlists.com/random-people?qty=1000")
//        self.ref.child("modules/public/famous").setValue(listFamous)
//
//    }
//    
//    func fetchFamousPage(URL: String) {
//        guard let pageURL = NSURL(string: URL) else {
//            print("Error: \(URL) doesn't seem to be a valid URL")
//            return
//        }
//        var pageHTML:String?
//        do {
//            pageHTML = try String(contentsOfURL: pageURL, encoding: NSUTF8StringEncoding)
//        } catch let error as NSError {
//            print("Error: \(error)")
//        }
//        
//        if let doc = Kanna.HTML(html: pageHTML!, encoding: NSUTF8StringEncoding) {
//            for link in doc.xpath("//span[@class='name']") {
//                var name = link.text!
//                if name == "Sean Combs" {
//                    listFamous.append("P. Diddy")
//                }
//                listFamous.append(name)
//            }
//        }
//    }
//    
//    
//    var listCelebs = [String]()
//    func fetchCelebs() {
//        fetchCelebsPage("http://www.vulture.com/2015/11/vultures-most-valuable-stars-of-2015.html")
//        fetchArtistsPage("http://www.billboard.com/charts/artist-100")
//        fetchRandomCelebs("https://www.randomlists.com/random-celebrities?qty=1000")
//        self.ref.child("modules/public/celebs").setValue(listCelebs)
//    }
//    
//    func fetchRandomCelebs(URL: String) {
//        guard let pageURL = NSURL(string: URL) else {
//            print("Error: \(URL) doesn't seem to be a valid URL")
//            return
//        }
//        var pageHTML:String?
//        do {
//            pageHTML = try String(contentsOfURL: pageURL, encoding: NSUTF8StringEncoding)
//        } catch let error as NSError {
//            print("Error: \(error)")
//        }
//        
//        if let doc = Kanna.HTML(html: pageHTML!, encoding: NSUTF8StringEncoding) {
//            for link in doc.xpath("//span[@class='name']") {
//                var name = link.text!
//                if !listCelebs.contains(name) {
//                    
//                    listCelebs.append(name)
//                }
//                
//            }
//        }
//    }
//    func fetchCelebsPage(URL: String) {
//        guard let pageURL = NSURL(string: URL) else {
//            print("Error: \(URL) doesn't seem to be a valid URL")
//            return
//        }
//        var pageHTML:String?
//        do {
//            pageHTML = try String(contentsOfURL: pageURL, encoding: NSUTF8StringEncoding)
//        } catch let error as NSError {
//            print("Error: \(error)")
//        }
//        
//        if let doc = Kanna.HTML(html: pageHTML!, encoding: NSUTF8StringEncoding) {
//            for link in doc.xpath("//div[@class='valuable-stars-list']/section/div/h2") {
//                var name = link.text!
//                let index = name.characters.indexOf("\n")
//                
//                let truncated = name.substringToIndex(index!)
//                
//                listCelebs.append(truncated)
//                
//            }
//        }
//    }
//    func fetchArtistsPage(URL: String) {
//        guard let pageURL = NSURL(string: URL) else {
//            print("Error: \(URL) doesn't seem to be a valid URL")
//            return
//        }
//        var pageHTML:String?
//        do {
//            pageHTML = try String(contentsOfURL: pageURL, encoding: NSUTF8StringEncoding)
//        } catch let error as NSError {
//            print("Error: \(error)")
//        }
//        
//        if let doc = Kanna.HTML(html: pageHTML!, encoding: NSUTF8StringEncoding) {
//            for link in doc.xpath("//h2[@class='chart-row__song']") {
//                var name = link.text!
//                
//                listCelebs.append(name)
//                
//            }
//        }
//    }
//    
//    
//    var listTV = [String]()
//    func fetchTV() {
//        fetchTVPage("http://www.hollywoodreporter.com/lists/best-tv-shows-ever-top-819499/item/friends-hollywoods-100-favorite-tv-821361")
//        self.ref.child("modules/public/tv").setValue(listTV)
//    }
//    
//    func fetchTVPage(URL: String) {
//        guard let pageURL = NSURL(string: URL) else {
//            print("Error: \(URL) doesn't seem to be a valid URL")
//            return
//        }
//        var pageHTML:String?
//        do {
//            pageHTML = try String(contentsOfURL: pageURL, encoding: NSUTF8StringEncoding)
//        } catch let error as NSError {
//            print("Error: \(error)")
//        }
//        
//        if let doc = Kanna.HTML(html: pageHTML!, encoding: NSUTF8StringEncoding) {
//            for link in doc.xpath("//h1[@class='list-item__title']") {
//                listTV.append(link.text!)
//                
//            }
//        }
//    }
//    
//    
//    var listMovies = [String]()
//    func fetchMovies() {
//        for i in 1...7 {
//            fetchMoviesPage("http://www.boxofficemojo.com/alltime/world/?pagenum=\(i)&p=.htm")
//        }
//        self.ref.child("modules/public/movies").setValue(listMovies)
//    }
//    
//    func fetchMoviesPage(URL: String) {
//        guard let pageURL = NSURL(string: URL) else {
//            print("Error: \(URL) doesn't seem to be a valid URL")
//            return
//        }
//        var pageHTML:String?
//        do {
//            pageHTML = try String(contentsOfURL: pageURL, encoding: NSUTF8StringEncoding)
//        } catch let error as NSError {
//            print("Error: \(error)")
//        }
//        
//        if let doc = Kanna.HTML(html: pageHTML!, encoding: NSUTF8StringEncoding) {
//            for link in doc.xpath("//a[starts-with(@href,'/movies/?id=')]/b") {
//                listMovies.append(link.text!)
//                
//            }
//        }
//    }
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

