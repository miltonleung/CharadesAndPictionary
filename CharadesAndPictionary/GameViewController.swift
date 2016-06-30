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
    var nextPlayer: String?
    
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var name4: UILabel!
    @IBOutlet weak var name5: UILabel!
    @IBOutlet weak var name6: UILabel!
    @IBOutlet weak var player1: UIButton!
    @IBAction func player1(sender: AnyObject) {
        if currentPlayer == myName {
            if myName == name1.text {
                label.text = "Can't guess your own answer"
            }
            else if done!.count - 1 != movies?.count {
                updateButtonOnTap(sender, number: 1)
            } else {
                newPick()
            }
        } else {
            label.text = "\(currentPlayer)'s Turn"
        }
    }
    @IBOutlet weak var player2: UIButton!
    @IBAction func player2(sender: AnyObject) {
        if currentPlayer == myName {
            if myName == name2.text {
                label.text = "Can't guess your own answer"
            }
            else if done!.count - 1 != movies?.count && currentPlayer == myName {
                updateButtonOnTap(sender, number: 2)
            } else {
                newPick()
            }
        } else {
            label.text = "\(currentPlayer)'s Turn"
        }
    }
    @IBOutlet weak var player3: UIButton!
    @IBAction func player3(sender: AnyObject) {
        if currentPlayer == myName {
            if myName == name3.text {
                label.text = "Can't guess your own answer"
            }
            else if done!.count - 1 != movies?.count && currentPlayer == myName {
                updateButtonOnTap(sender, number: 3)
            } else {
                newPick()
            }
        } else {
            label.text = "\(currentPlayer)'s Turn"
        }
    }
    @IBOutlet weak var player4: UIButton!
    @IBAction func player4(sender: AnyObject) {
        if currentPlayer == myName {
            if myName == name4.text {
                label.text = "Can't guess your own answer"
            }
            else if done!.count - 1 != movies?.count && currentPlayer == myName {
                updateButtonOnTap(sender, number: 4)
            } else {
                newPick()
            }
        } else {
            label.text = "\(currentPlayer)'s Turn"
        }
    }
    @IBOutlet weak var player5: UIButton!
    @IBAction func player5(sender: AnyObject) {
        if currentPlayer == myName {
            if myName == name5.text {
                label.text = "Can't guess your own answer"
            }
            else if done!.count - 1 != movies?.count && currentPlayer == myName {
                updateButtonOnTap(sender, number: 5)
            } else {
                newPick()
            }
        } else {
            label.text = "\(currentPlayer)'s Turn"
        }
    }
    @IBOutlet weak var player6: UIButton!
    @IBAction func player6(sender: AnyObject) {
        if currentPlayer == myName {
            if myName == name6.text {
                label.text = "Can't guess your own answer"
            }
            else if done!.count - 1 != movies?.count && currentPlayer == myName {
                updateButtonOnTap(sender, number: 6)
            } else {
                newPick()
            }
        } else {
            label.text = "\(currentPlayer)'s Turn"
        }
    }
    @IBOutlet weak var next: UIButton!
    @IBAction func next(sender: AnyObject) {
        newPick()
    }
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        movies = NSUserDefaults.standardUserDefaults().arrayForKey("movies") as? [String]
//        movies = ["The Other Guys", "Wolf of Wall Street"]
        
        
        //        scores = ["Milton": ["Threat Level Midnight"]]
        ModelInterface.sharedInstance.readRoom(roomName!, completion: { players -> Void in
            let playersDict = players["scores"] as! [String: [String]]
            self.scores = playersDict
            self.ready = players["ready"] as? [String]
            self.players = players["players"] as? [String]
            
            
            
            self.hideButtons()
            self.index = players["currentSelection"] as? Int
            self.currentPlayer = players["currentPlayer"] as? String
            if myName == self.currentPlayer {
                self.label.text = self.movies![self.index!]
                self.next.hidden = false
            } else {
                self.label.text = "\(self.currentPlayer)'s Turn"
                self.next.hidden = true
            }
            self.done = players["done"] as? [Int]
        })
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
    }
    
    func willEnterBackground() {
        var subPlayer:String = "Michael Scott"
        if players!.contains(myName) {
            let index = players?.indexOf(myName)
            players?.removeAtIndex(index!)
            
        }
        if ready!.contains(myName) {
            let index = ready?.indexOf(myName)
            ready?.removeAtIndex(index!)
        }
        if currentPlayer == myName && ready!.count > 1 {
            subPlayer = ready![1]
        }
        isLeader = false
        ModelInterface.sharedInstance.iamleavinggame(roomName!, ready: ready!, players: players!, currentPlayer: subPlayer)
    }
    
    func updateButtonOnTap(sender: AnyObject, number: Int) {
        
        if let currentNumber = NSNumberFormatter().numberFromString(sender.currentTitle!!) {
            sender.setTitle("\(currentNumber.integerValue + 1)", forState: UIControlState.Normal)
            switch number {
            case 1:
                scores![name1.text!]!.append(self.movies![index!])
                nextPlayer = name1.text
                ModelInterface.sharedInstance.updateScore(roomName!, player: name1.text!, newScore: scores![name1.text!]!)
            case 2:
                scores![name2.text!]!.append(self.movies![index!])
                nextPlayer = name2.text
                ModelInterface.sharedInstance.updateScore(roomName!, player: name2.text!, newScore: scores![name2.text!]!)
            case 3:
                scores![name3.text!]!.append(self.movies![index!])
                nextPlayer = name3.text
                ModelInterface.sharedInstance.updateScore(roomName!, player: name3.text!, newScore: scores![name3.text!]!)
            case 4:
                scores![name4.text!]!.append(self.movies![index!])
                nextPlayer = name4.text
                ModelInterface.sharedInstance.updateScore(roomName!, player: name4.text!, newScore: scores![name4.text!]!)
            case 5:
                scores![name5.text!]!.append(self.movies![index!])
                nextPlayer = name5.text
                ModelInterface.sharedInstance.updateScore(roomName!, player: name5.text!, newScore: scores![name5.text!]!)
            case 6:
                scores![name6.text!]!.append(self.movies![index!])
                nextPlayer = name6.text
                ModelInterface.sharedInstance.updateScore(roomName!, player: name6.text!, newScore: scores![name6.text!]!)
            default: break
            }
        }
        newPick()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func hideButtons() {
        player1.hidden = true
        player2.hidden = true
        player3.hidden = true
        player4.hidden = true
        player5.hidden = true
        player6.hidden = true
        
        name1.hidden = true
        name2.hidden = true
        name3.hidden = true
        name4.hidden = true
        name5.hidden = true
        name6.hidden = true
        
        var results = [[String]]()

        for name in ready! {
            if name != "Michael Scott" {
                results.append(scores![name]!)
            }
        }
        
        
        if ready!.count > 1 {
            player1.hidden = false
            name1.hidden = false
            name1.text = "\(ready![1])"
            player1.setTitle("\(results[0].count - 1)", forState: UIControlState.Normal)
        }
        if ready!.count > 2 {
            player2.hidden = false
            name2.hidden = false
            name2.text = "\(ready![2])"
            player2.setTitle("\(results[1].count - 1)", forState: UIControlState.Normal)
        }
        if ready!.count > 3 {
            player3.hidden = false
            name3.hidden = false
            name3.text = "\(ready![3])"
            player3.setTitle("\(results[2].count - 1)", forState: UIControlState.Normal)
        }
        if ready!.count > 4 {
            player4.hidden = false
            name4.hidden = false
            name4.text = "\(ready![4])"
            player4.setTitle("\(results[3].count - 1)", forState: UIControlState.Normal)
        }
        if ready!.count > 5 {
            player5.hidden = false
            name5.hidden = false
            name5.text = "\(ready![5])"
            player5.setTitle("\(results[4].count - 1)", forState: UIControlState.Normal)
        }
        if ready!.count > 6 {
            player6.hidden = false
            name6.hidden = false
            name6.text = "\(ready![6])"
            player6.setTitle("\(results[5].count - 1)", forState: UIControlState.Normal)
        }
    }
    
    func newPick() {
        var rand:Int?
        if (done?.count)! - 1 != (movies?.count)! {
            repeat {
                rand = Int(arc4random_uniform(UInt32(movies!.count)))
            }  while done!.contains(rand!)
            done?.append(rand!)
            ModelInterface.sharedInstance.updateDone(roomName!, done: done!)
            label.text = movies![rand!]
            ModelInterface.sharedInstance.updateTurn(roomName!, currentSelection: rand!, currentPlayer: nextPlayer!, category: "movies")
            
        } else {
            label.text = "We're all out of movies"
        }
    }
    
}
