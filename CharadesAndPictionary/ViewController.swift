//
//  ViewController.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-06-22.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMovies() {
        
        let page1 = "http://www.boxofficemojo.com/alltime/world/?pagenum=1&p=.htm"
        //        let myURLString = "http://www.google.ca/"
        guard let page1URL = NSURL(string: page1) else {
            print("Error: \(page1) doesn't seem to be a valid URL")
            return
        }
        var page1HTML:String?
        do {
            page1HTML = try String(contentsOfURL: page1URL, encoding: NSUTF8StringEncoding)
//            print("HTML : \(page1HTML)")
        } catch let error as NSError {
            print("Error: \(error)")
        }
        
        if let doc = Kanna.HTML(html: page1HTML!, encoding: NSUTF8StringEncoding) {
            
            for link in doc.xpath("//a[starts-with(@href,'/movies/?id=')]/b") {
//            for link in doc.xpath("//a/b") {
                print(link.text)
            }
        }
        
    }


}

