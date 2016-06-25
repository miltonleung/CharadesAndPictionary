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

class ViewController: UIViewController {
    
    var ref = FIRDatabaseReference.init()
    var name:String?
    
    var lobbyRoom:String?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var roomField: UITextField!
    @IBAction func submit(sender: AnyObject) {
        print(roomField.text)
        let editedText = roomField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if editedText != "" && passwordField.text != "" && nameField != "" {
            NSUserDefaults.standardUserDefaults().setObject(nameField.text, forKey: "name")
            checkForRoom({ room -> Void in
                if self.isAvailable(editedText!, room: room) {
                    self.addRoom(editedText!)
                    //                    self.ref.child("rooms").child(editedText!).setValue(ready)
                    
                    //                    let myPlayer:[String: AnyObject] = ["\(self.nameField.text!)": ["Threat Level Midnight"]]
                    //                    self.ref.child("rooms/\(editedText!)/scores").setValue(myPlayer)
                    
                    self.performSegueWithIdentifier("lobbySegue", sender: nil)
                } else {
                    let attributes = room[editedText!] as! [String: AnyObject]
                    self.lobbyRoom = editedText!
                    if self.passwordField.text! == attributes["password"] as! String {
//                        let myPlayer:[String: AnyObject] = [self.nameField.text!: ["Threat Level Midnight"]]
//                        
                        let playerUpdates = ["rooms/\(editedText!)/scores/\(self.nameField.text!)/": ["Threat Level Midnight"]]
                        
                        self.ref.updateChildValues(playerUpdates)
                        
                        self.performSegueWithIdentifier("lobbySegue", sender: nil)
                    }
                }
            })
        }
        
    }
    
    func addRoom(editedText: String) {
        self.lobbyRoom = editedText
        self.ref.child("rooms/\(editedText)/password").setValue(self.passwordField.text!)
        self.ref.child("rooms/\(editedText)/ready").setValue(0)
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
        
        let nameExists = NSUserDefaults.standardUserDefaults().objectForKey("name")
        if nameExists != nil {
            name = nameExists as? String
            nameField.text = name
        }
        addFillerRoom()
        //        fetchMovies()
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

