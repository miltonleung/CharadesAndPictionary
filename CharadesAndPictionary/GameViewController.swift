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
    
    @IBOutlet weak var player1: UIButton!
    @IBAction func player1(sender: AnyObject) {
        sender.setTitle("1", forState: UIControlState.Normal)
        newPick()
    }
    @IBOutlet weak var player2: UIButton!
    @IBAction func player2(sender: AnyObject) {
        newPick()
    }
    @IBOutlet weak var player3: UIButton!
    @IBAction func player3(sender: AnyObject) {
        newPick()
    }
    @IBOutlet weak var player4: UIButton!
    @IBAction func player4(sender: AnyObject) {
        newPick()
    }
    @IBOutlet weak var player5: UIButton!
    @IBAction func player5(sender: AnyObject) {
        newPick()
    }
    @IBOutlet weak var player6: UIButton!
    @IBAction func player6(sender: AnyObject) {
        newPick()
    }
    @IBAction func next(sender: AnyObject) {
        newPick()
    }
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movies = NSUserDefaults.standardUserDefaults().arrayForKey("movies") as? [String]
        movies = ["The Other Guys", "Wolf of Wall Street"]
        scores = ["Milton": ["Threat Level Midnight"]]
        hideButtons()
        setupButtons()
        newPick()
        
        
        // Do any additional setup after loading the view.
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
        
        var names = [String]()
        var results = [[String]]()
        for (name, result) in scores! {
            names.append(name)
            results.append(result)
        }
        
        if scores!.count > 0 {
            player1.hidden = false
            player1.setTitle("\(names[0]) \(results[0].count - 1)", forState: UIControlState.Normal)
        }
        if scores!.count > 1 {
            player2.hidden = false
            player2.setTitle("\(names[1]) \(results[1].count - 1)", forState: UIControlState.Normal)
        }
        if scores!.count > 2 {
            player3.hidden = false
            player3.setTitle("\(names[2]) \(results[2].count - 1)", forState: UIControlState.Normal)
        }
        if scores!.count > 3 {
            player4.hidden = false
            player4.setTitle("\(names[3]) \(results[3].count - 1)", forState: UIControlState.Normal)
        }
        if scores!.count > 4 {
            player5.hidden = false
            player5.setTitle("\(names[4]) \(results[4].count - 1)", forState: UIControlState.Normal)
        }
        if scores!.count > 5 {
            player6.hidden = false
            player6.setTitle("\(names[5]) \(results[5].count - 1)", forState: UIControlState.Normal)
        }
    }
    
    func newPick() {
        let rand = Int(arc4random_uniform(UInt32(movies!.count)))
        label.text = movies![rand]
    }

}
