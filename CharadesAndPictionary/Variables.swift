//
//  Variables.swift
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

var badCharacters: Set<Character> = ["#", "[", "]", "*", "?", ".", "$"]