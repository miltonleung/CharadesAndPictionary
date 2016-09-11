//
//  GameViewController.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-06-24.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var movies:[String]?
    var scores:[String: [String]]?
    var roomName: String?
    var done:[Int]?
    var firstMovie:Int?
    var currentPlayer:String?
    var index:Int?
    var ready: [String]?
    var players: [String]?
    var avatars: [[String]]?
    var nextPlayer: String?
    var category:String?
    var ids:[String]?
    
    @IBOutlet weak var scroller: UIScrollView!
    
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var name4: UILabel!
    @IBOutlet weak var name5: UILabel!
    @IBOutlet weak var name6: UILabel!
    
    @IBOutlet weak var avatar1: UIView!
    @IBOutlet weak var avatar2: UIView!
    @IBOutlet weak var avatar3: UIView!
    @IBOutlet weak var avatar4: UIView!
    @IBOutlet weak var avatar5: UIView!
    @IBOutlet weak var avatar6: UIView!
    
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var player1: UIButton!
    @IBOutlet weak var player2: UIButton!
    @IBOutlet weak var player3: UIButton!
    @IBOutlet weak var player4: UIButton!
    @IBOutlet weak var player5: UIButton!
    @IBOutlet weak var player6: UIButton!
    
    var avatarViews:[UIView]?
    var playerButtons:[UIButton]?
    var nameLabels:[UILabel]?
    
    @IBAction func backButton(sender: AnyObject) {
        ModelInterface.sharedInstance.removeListener(roomName!)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
        performSegueWithIdentifier("lobbySegue", sender: nil)
    }
    
    @IBAction func selectPlayer(sender: AnyObject) {
        if currentPlayer == myName {
            if myName == nameLabels![sender.tag].text {
                label.text = "Can't guess your own answer"
            }
            else if done!.count != movies?.count {
                updateButtonOnTap(sender)
            } else {
                newPick()
            }
        } else {
            if let current = currentPlayer {
                label.text = "\(current)'s Turn"
            }
        }
    }

    @IBOutlet weak var next: UIButton!
    @IBAction func next(sender: AnyObject) {
        nextPlayer = currentPlayer
        newPick()
    }
    @IBOutlet weak var leadingFirst: NSLayoutConstraint!
    @IBOutlet weak var leadingSecond: NSLayoutConstraint!
    @IBOutlet weak var leadingThird: NSLayoutConstraint!
    @IBOutlet weak var leadingFourth: NSLayoutConstraint!
    @IBOutlet weak var leadingFifth: NSLayoutConstraint!
    @IBOutlet weak var leadingSixth: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomLabel.text = roomName
        
        avatarViews = [avatar1, avatar2, avatar3, avatar4, avatar5, avatar6]
        playerButtons = [player1 , player2 , player3 , player4 , player5 , player6]
        nameLabels = [name1, name2, name3, name4, name5, name6]

        self.view.setWhiteGradientBackground()
        
        ModelInterface.sharedInstance.readRoom(roomName!, completion: { players -> Void in
            
            if let playersDict = players["scores"] as? [String: [String]] {
                self.scores = playersDict
            } else {
                self.scores = [String: [String]]()
            }
            self.ready = players["ready"] as? [String]
            guard self.ready != nil && (self.ready?.contains(myName))! else {
                ModelInterface.sharedInstance.removeListener(self.roomName!)
                NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
                self.performSegueWithIdentifier("lobbySegue", sender: nil)
                return
            }
            let playersData = players["players"] as! [String: AnyObject]
            var existingPlayers = [String]()
            var existingAvatars = [[String]]()
            for (_, data) in playersData {
                for (name, avatar) in data as! [String: [String]] {
                    existingPlayers.append(name)
                    existingAvatars.append(avatar)
                }
            }
            self.players = existingPlayers
            self.avatars = existingAvatars
            
            
            self.hideButtons()
            self.index = players["currentSelection"] as? Int
            self.currentPlayer = players["currentPlayer"] as? String
            if myName == self.currentPlayer {
                self.label.text = self.movies![self.index!]
                self.next.hidden = false
            } else {
                if let current = self.currentPlayer {
                self.label.text = "\(current)'s Turn"
                }
                self.next.hidden = true
            }
            
            if let ids = players["ids"] as? [String] {
                self.ids = ids
            }
            
            if let leader = players["leader"] as? String {
                if leader == myName {
                    isLeader = true
                } else {
                    isLeader = false
                }
            }
            
            let totalDone = players["done"] as! [String: AnyObject]
            self.done = totalDone[self.category!] as? [Int]
            
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenWidth = screenSize.width
            
            if screenWidth == 414 {
                self.scroller.contentSize = CGSizeMake(screenWidth, 180)
                self.scroller.showsHorizontalScrollIndicator = false
                self.scroller.scrollEnabled = false
                self.leadingFirst.constant = 8
                self.leadingSecond.constant = 13
                self.leadingThird.constant = 13
                self.leadingFourth.constant = 13
                self.leadingFifth.constant = 13
                self.leadingSixth.constant = 13
                self.updateViewConstraints()
            } else if screenWidth == 375 {
                self.scroller.contentSize = CGSizeMake(screenWidth, 180)
                self.scroller.showsHorizontalScrollIndicator = false
                self.scroller.scrollEnabled = false
            } else if screenWidth < 375 {
                if self.players!.count <= 5 {
                    self.scroller.contentSize = CGSizeMake(screenWidth, 180)
                    self.scroller.showsHorizontalScrollIndicator = false
                    self.scroller.scrollEnabled = false
                } else if self.players!.count > 5 {
                    self.scroller.contentSize = CGSizeMake(screenWidth * 1.18, 180)
                    self.scroller.showsHorizontalScrollIndicator = true
                    self.scroller.scrollEnabled = true
                }
            }
        })
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
    }
    
    func willEnterBackground() {
        if ready!.contains(myName) {
            let index = ready?.indexOf(myName)
            ready?.removeAtIndex(index!)
        }
        if ids!.contains(id) {
            let index = ids?.indexOf(id)
            ids?.removeAtIndex(index!)
        }
        var newLeader:String?
        if isLeader == true {
            if players!.count >= 1 {
                for player in players! {
                    if player != myName {
                        newLeader = player
                        break
                    }
                }
                ModelInterface.sharedInstance.setLeader(roomName!, name: newLeader!)
            } else {
                ModelInterface.sharedInstance.removeLeader(roomName!)
            }
        }
        if currentPlayer == myName && ready!.count >= 1 {
            ModelInterface.sharedInstance.iamleavinggame(roomName!, ready: ready!, ids: ids!, currentPlayer: newLeader!)
        } else if currentPlayer == myName {
            ModelInterface.sharedInstance.iamleavinggame(roomName!, ready: ready!, ids: ids!)
        }
        
    }
    
    func updateButtonOnTap(sender: AnyObject) {
        if let currentNumber = NSNumberFormatter().numberFromString(sender.currentTitle!!) {
            sender.setTitle("\(currentNumber.integerValue + 1)", forState: UIControlState.Normal)
            scores![nameLabels![sender.tag].text!]!.append(self.movies![index!])
            nextPlayer = nameLabels![sender.tag].text
            ModelInterface.sharedInstance.updateScore(roomName!, player: nameLabels![sender.tag].text!, newScore: scores![nameLabels![sender.tag].text!]!)
        }
        newPick()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideButtons() {
        for player in playerButtons! {
            player.hidden = true
        }
        
        for name in nameLabels! {
            name.hidden = true
        }
        
        var results = [[String]]()

        for name in ready! {
            if scores?.indexForKey(name) != nil {
                results.append(scores![name]!)
            } else {
                scores![name] = [String]()
                results.append(scores![name]!)
            }
        }
        
        for i in 0...(ready?.count)! - 1 {
            playerButtons![i].hidden = false
            playerButtons![i].setTitle("\(results[i].count)", forState: UIControlState.Normal)
            nameLabels![i].hidden = false
            nameLabels![i].text = "\(ready![i])"
        }
    }
    
    func newPick() {
        var rand:Int?
        if (done?.count)! != (movies?.count)! {
            repeat {
                rand = Int(arc4random_uniform(UInt32(movies!.count)))
            }  while done!.contains(rand!)
            done?.append(rand!)
            ModelInterface.sharedInstance.updateDone(roomName!, done: done!, category: category!)
            label.text = movies![rand!]
            ModelInterface.sharedInstance.updateTurn(roomName!, currentSelection: rand!, currentPlayer: nextPlayer!, category: "movies")
            
        } else {
            label.text = "We're all out of items"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "lobbySegue") {
            let lobby = segue.destinationViewController as! LobbyViewController
            lobby.roomName = roomName
        }
        else {
            super.prepareForSegue(segue, sender: sender)
        }
    }
    
}
