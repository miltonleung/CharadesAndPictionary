//
//  CharadesAndPictionaryTests.swift
//  CharadesAndPictionaryTests
//
//  Created by Milton Leung on 2016-06-22.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import XCTest
@testable import CharadesAndPictionary

class CharadesAndPictionaryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    func testDownloadURL() {
        let page1 = "http://www.boxofficemojo.com/alltime/world/?pagenum=1&p=.htm"
//        let myURLString = "http://www.google.ca/"
        guard let page1URL = NSURL(string: page1) else {
            print("Error: \(page1) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOfURL: page1URL, encoding: NSUTF8StringEncoding)
            print("HTML : \(myHTMLString)")
        } catch let error as NSError {
            print("Error: \(error)")
        }
    }
}
