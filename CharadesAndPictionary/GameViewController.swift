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
    
    @IBOutlet weak var player1: UIButton!
    @IBAction func player1(sender: AnyObject) {
        sender.setTitle("1", forState: UIControlState.Normal)
    }
    @IBAction func next(sender: AnyObject) {
        newPick()
    }
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movies = NSUserDefaults.standardUserDefaults().arrayForKey("movies") as? [String]
        newPick()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newPick() {
        let rand = Int(arc4random_uniform(UInt32(movies!.count)))
        label.text = movies![rand]
    }

}
