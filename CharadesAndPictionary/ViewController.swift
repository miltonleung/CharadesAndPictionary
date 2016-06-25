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
    
    var lobbyRoom:String?
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var roomField: UITextField!
    @IBAction func submit(sender: AnyObject) {
        print(roomField.text)
        let editedText = roomField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if editedText != "" && passwordField.text != "" {
            checkForRoom({ room -> Void in
                if self.isAvailable(editedText!, room: room) {
                    self.lobbyRoom = editedText
                    let password:[String: AnyObject] = ["password": self.passwordField.text!]
                    self.ref.child("rooms").child(editedText!).setValue(password)
                    
                    self.performSegueWithIdentifier("lobbySegue", sender: nil)
                } else {
                    let attributes = room[editedText!] as! [String: AnyObject]
//                    for (existingRoom, child) in room {
                        self.lobbyRoom = editedText!
//                        let password:String = attributes["password"] as! String
                        print(attributes["password"] as! String)
                        print(self.passwordField.text!)
                        if self.passwordField.text! == attributes["password"] as! String {
                            self.performSegueWithIdentifier("lobbySegue", sender: nil)
                        }
//                    }
                    
                }
            })
        }
        
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
                else {
                    return true
                }
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = FIRDatabase.database().reference()
        //        fetchMovies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        ref.child("rooms").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            let roomData = snapshot.value as! [String: AnyObject]
            print(snapshot.value)
            completion(roomData)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func fetchMovies() {
        for i in 1...7 {
            fetchPage("http://www.boxofficemojo.com/alltime/world/?pagenum=\(i)&p=.htm")
        }
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
                print(link.text)
            }
        }
    }
    
    
}

