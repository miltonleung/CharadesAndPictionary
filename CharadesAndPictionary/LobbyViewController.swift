//
//  LobbyViewController.swift
//
//
//  Created by Milton Leung on 2016-06-23.
//
//

import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var roomNameLabel: UILabel!
    
    @IBOutlet weak var player1: UILabel!
    @IBOutlet weak var player2: UILabel!
    @IBOutlet weak var player3: UILabel!
    @IBOutlet weak var player4: UILabel!
    @IBOutlet weak var player5: UILabel!
    @IBOutlet weak var player6: UILabel!
    
    @IBOutlet weak var status1: UILabel!
    @IBOutlet weak var status2: UILabel!
    @IBOutlet weak var status3: UILabel!
    @IBOutlet weak var status4: UILabel!
    @IBOutlet weak var status5: UILabel!
    @IBOutlet weak var status6: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var isReady:Bool = false
    var canStart:Bool = false
    var timer = NSTimer()
    var categorySelected = false
    var category:String?
    @IBAction func readyButton(sender: AnyObject) {
        if isReady == false {
            isReady = true
            if !ready!.contains(myName) {
                ready?.append(myName)
            }
        } else {
            isReady = false
            if ready!.contains(myName) {
                let index = ready?.indexOf(myName)
                ready?.removeAtIndex(index!)
            }
        }
        ModelInterface.sharedInstance.iamready(roomName!, ready: ready!)
    }
    
    
    @IBOutlet weak var startButton: UIButton!
    @IBAction func startButton(sender: AnyObject) {
        if canStart == true && categorySelected == true{
            countDownTime = 8
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LobbyViewController.updateCountdown), userInfo: nil, repeats: true)
        }
    }
    @IBAction func movies(sender: AnyObject) {
        if isLeader == true {
            categorySelected = true
            category = "movies"
            
            if category == "movies" {
                rand = Int(arc4random_uniform(UInt32(movies!.count)))
                
            }
            let currentPlayer = players![rand! % (players?.count)!]
            ModelInterface.sharedInstance.updateTurn(self.roomName!, currentSelection: self.rand!, currentPlayer: currentPlayer, category: category!)
        }
        
    }
    var roomName:String?
    var movies:[String]?
    var rand:Int?
    var players:[String]?
    var ready:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomNameLabel.text = roomName
        movies = NSUserDefaults.standardUserDefaults().arrayForKey("movies") as? [String]
        //        if isLeader == true {
        setupGame("movies")
        //        }
        if isLeader == true {
        startButton.alpha = 0.5
        } else {
            startButton.hidden = true
        }
        canStart = false
    }
    
    func updateCountdown() {
        if countDownTime > 0 {
            if canStart == true {
                countDownTime -= 1
                timerLabel.text = "\(countDownTime)"
            } else {
                timer.invalidate()
            }
        } else {
            timer.invalidate()
            performSegueWithIdentifier("movieSegue", sender: nil)
        }
    }
    
    func setupLabels() {
        player1.hidden = true
        player2.hidden = true
        player3.hidden = true
        player4.hidden = true
        player5.hidden = true
        player6.hidden = true
        
        status1.hidden = true
        status2.hidden = true
        status3.hidden = true
        status4.hidden = true
        status5.hidden = true
        status6.hidden = true
        
        if players!.count > 0 {
            player1.hidden = false
            status1.hidden = false
            status1.text = "not ready"
            player1.text = players![0]
        }
        if players!.count > 1 {
            player2.hidden = false
            status2.hidden = false
            status2.text = "not ready"
            player2.text = players![1]
        }
        if players!.count > 2 {
            player3.hidden = false
            status3.hidden = false
            status3.text = "not ready"
            player3.text = players![2]
        }
        if players!.count > 3 {
            player4.hidden = false
            status4.hidden = false
            status4.text = "not ready"
            player4.text = players![3]
        }
        if players!.count > 4 {
            player5.hidden = false
            status5.hidden = false
            status5.text = "not ready"
            player5.text = players![4]
        }
        if players!.count > 5 {
            player6.hidden = false
            status6.hidden = false
            status6.text = "not ready"
            player6.text = players![5]
        }
        
        for player in ready! {
            if let index = players?.indexOf("\(player)") {
                switch Int(index) {
                case 0:
                    status1.text = "ready"
                case 1:
                    status2.text = "ready"
                case 2:
                    status3.text = "ready"
                case 3:
                    status4.text = "ready"
                case 4:
                    status5.text = "ready"
                case 5:
                    status6.text = "ready"
                default: break
                }
            }
        }
    }
    
    // Sets up the first person to go and the first thing to see
    func setupGame(category: String) {
        
        
        ModelInterface.sharedInstance.readRoom(roomName!, completion: { room -> Void in
            //            self.players = room["scores"] as? [String: [String]]
            self.players = room["players"] as? [String]
            self.ready = room["ready"] as? [String]
            self.setupLabels()
            
            if self.players!.count == self.ready!.count - 1 {
                self.canStart = true
                self.startButton.alpha = 1
            } else {
                self.canStart = false
                self.startButton.alpha = 0.5
            }
            
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieSegue" {
            let movie = segue.destinationViewController as! GameViewController
            movie.roomName = roomName
            movie.movies = movies
            if isLeader == true {
                movie.firstMovie = self.rand
            }
        }
    }
}
