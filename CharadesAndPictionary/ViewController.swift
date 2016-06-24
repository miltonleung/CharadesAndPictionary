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
        
        for i in 1...7 {
            fetchPage("http://www.boxofficemojo.com/alltime/world/?pagenum=\(i)&p=.htm")
        }
        
    }
    
    func fetchPage(URL: String) {
        guard let pageURL = NSURL(string: URL) else {
            print("Error: \(URL) doesn't seem to be a valid URL")
            return
        }
        var pageHTML:String?
        do {
            pageHTML = try String(contentsOfURL: pageURL, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print("Error: \(error)")
        }
        
        if let doc = Kanna.HTML(html: pageHTML!, encoding: NSUTF8StringEncoding) {
            for link in doc.xpath("//a[starts-with(@href,'/movies/?id=')]/b") {
                print(link.text)
            }
        }
    }


}

