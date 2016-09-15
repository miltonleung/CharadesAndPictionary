//
//  SelectListViewController.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-11.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

protocol SelectListViewControllerDelegate {
    func customCategoryAction(listName: String)
}

class SelectListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var module:AnyObject?
    var moduleName:String?
    var listIsPublic:Bool?
    
    var delegate:SelectListViewControllerDelegate?
    
    @IBOutlet weak var selectListView: UIView!
    
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var listDescription: UILabel!
    
    @IBOutlet weak var Contributors: UILabel!
    
    @IBOutlet weak var entryCounter: UILabel!
    
    @IBOutlet weak var select: UIButton!
    @IBAction func selectButton(sender: AnyObject) {
        if isLeader {
            delegate?.customCategoryAction(moduleName!)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var cancel: UIButton!
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func closeView() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAppearance()
        updateCount()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.5
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.insertSubview(blurEffectView, atIndex: 0)
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(SelectListViewController.closeView))
        view.subviews.first?.addGestureRecognizer(closeTap)
        
        listName.text = moduleName
        listDescription.text = module!["description"] as! String
        let authors = module!["author"] as! [String]
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
        self.selectListView.layer.borderColor = UIColor(red: 82/255.0, green: 82/255.0, blue: 82/255.0, alpha: 1.0).CGColor
        self.selectListView.layer.backgroundColor = UIColor.whiteColor().CGColor
    }

    func updateCount() {
        
        ModelInterface.sharedInstance.fetchListCount(listIsPublic!, listName: moduleName!, completion: { count -> Void in
            self.entryCounter.text = "\(count)"
        })
        
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
