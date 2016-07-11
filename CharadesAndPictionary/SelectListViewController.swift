//
//  SelectListViewController.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-11.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class SelectListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var module:AnyObject?
    var moduleName:String?
    
    @IBOutlet weak var selectListView: UIView!
    
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var listDescription: UILabel!
    
    @IBOutlet weak var Contributors: UILabel!
    

    
    @IBOutlet weak var select: UIButton!
    @IBAction func selectButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var cancel: UIButton!
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAppearance()
        
        listName.text = moduleName
        listDescription.text = module!["description"] as! String
        var authors = module!["author"] as! [String]
        authors.removeFirst()
        items = authors
        
        if isLeader {
            select.setTitle("select", forState: .Normal)
        } else {
            select.setTitle("OK", forState: .Normal)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAppearance() {
        selectListView.layer.cornerRadius = 24
        self.selectListView.layer.borderWidth = 2
        self.selectListView.layer.borderColor = UIColor(red: 214/255.0, green: 214/255.0, blue: 214/255.0, alpha: 1.0).CGColor
        self.selectListView.layer.backgroundColor = UIColor(red: 225/255.0, green: 243/255.0, blue: 247/255.0, alpha: 1.0).CGColor
    }

    
    
    let reuseIdentifier = "cell"
    var items = [String]()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ContributorsLabelCollectionViewCell
        
        cell.name.text = self.items[indexPath.item]
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
}
