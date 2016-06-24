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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomNameLabel.text = roomName
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieSegue" {
            let movie = segue.destinationViewController as! GameViewController
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
