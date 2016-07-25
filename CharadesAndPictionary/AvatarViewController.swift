//
//  AvatarViewController.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-24.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class AvatarViewController: UIViewController {

    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var flowChartView: UIScrollView!
    @IBAction func button(sender: AnyObject) {
        let offset = flowChartView.contentOffset.y
        self.flowChartView.setContentOffset(CGPoint(x: 0, y: offset + 80.0), animated: true)

    }
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        femaleButton.setImage(UIImage(named: "Female"), forState: .Normal)
        maleButton.setImage(UIImage(named: "Male"), forState: .Normal)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
