//
//  StringUtil.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-12.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation

class StringUtil {
    
    static func containsSymbols(string: String) -> Bool {
        let sharedCharacters = badCharacters.intersect(string.characters)
        if sharedCharacters.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    static func isStringEmpty(string: String) -> Bool {
        let edited = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if edited.characters.count > 0 {
            return false
        } else {
            return true
        }
    }
    
}