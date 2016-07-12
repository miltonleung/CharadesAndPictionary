//
//  StringUtil.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-12.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation

class StringUtil {
    
    
    static func checkForSymbols(string: String) -> Bool {
        let sharedCharacters = badCharacters.intersect(string.characters)
        if sharedCharacters.count > 0 {
            return true
        } else {
            return false
        }
    }
    
}