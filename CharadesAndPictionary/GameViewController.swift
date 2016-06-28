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
    @IBAction func next(sender: AnyObject) {
        newPick()
    }
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movies = NSUserDefaults.standardUserDefaults().arrayForKey("movies") as? [String]
//        movies = ["The Other Guys", "Wolf of Wall Street"]
        
        
        //        scores = ["Milton": ["Threat Level Midnight"]]
        ModelInterface.sharedInstance.readRoom(roomName!, completion: { players -> Void in
            let playersDict = players["scores"] as! [String: [String]]
            self.scores = playersDict
            self.hideButtons()
            self.setupButtons()
            self.index = players["currentSelection"] as! Int
            self.currentPlayer = players["currentPlayer"] as? String
            if myName == self.currentPlayer {
                self.label.text = self.movies![self.index!]
            } else {
                self.label.text = "\(self.currentPlayer)'s Turn"
            }
            self.done = players["done"] as? [Int]
        })
        
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func updateButtonOnTap(sender: AnyObject, number: Int) {
        
        if let currentNumber = NSNumberFormatter().numberFromString(sender.currentTitle!!) {
            sender.setTitle("\(currentNumber.integerValue + 1)", forState: UIControlState.Normal)
            switch number {
            case 1:
                scores![name1.text!]!.append(self.movies![index!])
                ModelInterface.sharedInstance.updateScore(roomName!, player: name1.text!, newScore: scores![name1.text!]!)
            case 2:
                scores![name2.text!]!.append(self.movies![index!])
                ModelInterface.sharedInstance.updateScore(roomName!, player: name2.text!, newScore: scores![name2.text!]!)
            case 3:
                scores![name3.text!]!.append(self.movies![index!])
                ModelInterface.sharedInstance.updateScore(roomName!, player: name3.text!, newScore: scores![name3.text!]!)
            case 4:
                scores![name4.text!]!.append(self.movies![index!])
                ModelInterface.sharedInstance.updateScore(roomName!, player: name4.text!, newScore: scores![name4.text!]!)
            case 5:
                scores![name5.text!]!.append(self.movies![index!])
                ModelInterface.sharedInstance.updateScore(roomName!, player: name5.text!, newScore: scores![name5.text!]!)
            case 6:
                scores![name6.text!]!.append(self.movies![index!])
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
    func setupButtons() {
        var names = [String]()
        var results = [[String]]()
        for (name, result) in scores! {
            names.append(name)
            results.append(result)
        }
        
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
        
        var names = [String]()
        var results = [[String]]()
        for (name, result) in scores! {
            names.append(name)
            results.append(result)
        }
        
        if scores!.count > 0 {
            player1.hidden = false
            name1.hidden = false
            name1.text = "\(names[0])"
            player1.setTitle("\(results[0].count - 1)", forState: UIControlState.Normal)
        }
        if scores!.count > 1 {
            player2.hidden = false
            name2.hidden = false
            name2.text = "\(names[1])"
            player2.setTitle("\(results[1].count - 1)", forState: UIControlState.Normal)
        }
        if scores!.count > 2 {
            player3.hidden = false
            name3.hidden = false
            name3.text = "\(names[2])"
            player3.setTitle("\(results[2].count - 1)", forState: UIControlState.Normal)
        }
        if scores!.count > 3 {
            player4.hidden = false
            name4.hidden = false
            name4.text = "\(names[3])"
            player4.setTitle("\(results[3].count - 1)", forState: UIControlState.Normal)
        }
        if scores!.count > 4 {
            player5.hidden = false
            name5.hidden = false
            name5.text = "\(names[4])"
            player5.setTitle("\(results[4].count - 1)", forState: UIControlState.Normal)
        }
        if scores!.count > 5 {
            player6.hidden = false
            name6.hidden = false
            name6.text = "\(names[5])"
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
            ModelInterface.sharedInstance.updateTurn(roomName!, currentSelection: rand!, currentPlayer: myName, category: "movies")
            
        } else {
            label.text = "We're all out of movies"
        }
    }
    
}
