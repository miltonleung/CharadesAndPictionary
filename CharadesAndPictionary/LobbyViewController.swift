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
    
    @IBAction func movies(sender: AnyObject) {
        
        performSegueWithIdentifier("movieSegue", sender: nil)
    }
    var roomName:String?
    var movies:[String]?
    var rand:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomNameLabel.text = roomName
        movies = NSUserDefaults.standardUserDefaults().arrayForKey("movies") as? [String]
        if isLeader == true {
            setupGame("movies")
        }
    }

    // Sets up the first person to go and the first thing to see
    func setupGame(category: String) {
        
        if category == "movies" {
            rand = Int(arc4random_uniform(UInt32(movies!.count)))
            
        }
//        ModelInterface.sharedInstance.readRoom(roomName!, completion: { room -> Void in
//            let players = room["scores"] as! [String: [String]]
//            let currentPlayer = players.first?.0
//            ModelInterface.sharedInstance.updateTurn(self.roomName!, currentSelection: self.rand!, currentPlayer: currentPlayer!, category: "movies")
//            
//        })
        
        ModelInterface.sharedInstance.readRoomOnce(roomName!, completion: { room -> Void in
            let players = room["scores"] as! [String: [String]]
            let currentPlayer = players.first?.0
            ModelInterface.sharedInstance.updateTurn(self.roomName!, currentSelection: self.rand!, currentPlayer: currentPlayer!, category: "movies")
            
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
            movie.firstMovie = self.rand
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
