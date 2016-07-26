//
//  Constants.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-06-26.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation
import Firebase

var myName = ""

var isLeader = false

let ref = FIRDatabase.database().reference()

var countDownTime = 8

var isPrivate = false

var stockLists:[String] = ["movies", "tv", "famous", "celebs"]

enum ErrorMessages {
    static let emptyName = "Please enter a name"
    static let emptyRoom = "Please enter a room name"
    static let symbols = "Please refrain from using # [ ] * ? . or $"
}

enum category {
    static let gender = 0
    static let skinColor = 1
    static let hair = 2
    static let top = 3
    static let topColor = 4
    static let pants = 5
    static let shoes = 6
    static let accessories = 7
}

enum avatarImages {
    static let skinColorMale = ["MaleBrownFaceIcon", "MaleDBrownIcon", "MaleWhiteFaceIcon"]
}

var badCharacters: Set<Character> = ["#", "[", "]", "*", "?", ".", "$"]