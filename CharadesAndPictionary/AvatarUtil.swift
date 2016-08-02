//
//  AvatarUtil.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-07-25.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation

class AvatarUtil {
    
    static func randomAvatar() -> ([[String]], [String]) {
        let randPath = Int(arc4random_uniform(UInt32(avatarPaths.count)))
        let path = avatarPaths[randPath]
        
        let randItem = Int(arc4random_uniform(UInt32(6)))
        var imageStrings = [String]()
        for item in path {
            if item == path[1] && (path == avatarPaths[2] || path == avatarPaths[3]) {
                imageStrings.append(avatarImages.headMale[randItem % avatarImages.headMale.count])
            }
            if item == path[3] {
                var rand:Int?
                if path == womenOutfitPath {
                        let options = [0, 3]
                        rand = options[randItem % options.count]
                } else if path == womenTPath {
                    let options = [1, 2]
                    rand = options[randItem % options.count]
                } else if path == maleTPath {
                    rand = 2
                } else if path == maleOutfitPath {
                    let options = [0, 1, 3]
                    rand = options[randItem % options.count]
                }
                imageStrings.append(item[rand!])
            } else {
                imageStrings.append(item[randItem % item.count])
            }
        }
        return (path, imageStrings)
    }
    
    static func arrangeAvatar(avatarPath: [[String]], images: [String]) -> [String] {
        var imageStrings = images
        if avatarPath == womenTPath {
            imageStrings.append(imageStrings.removeAtIndex(3))
            imageStrings.append(imageStrings.removeAtIndex(0))
            
        } else if avatarPath == womenOutfitPath {
            imageStrings.append(imageStrings.removeAtIndex(0))
        } else if avatarPath == maleTPath {
            imageStrings.append(imageStrings.removeAtIndex(5))
            imageStrings.append(imageStrings.removeAtIndex(0))
            if imageStrings.count >= 7 {
                if (imageStrings.contains(avatarImages.hairMale[0]) || imageStrings.contains(avatarImages.hairMale[3])) && imageStrings.contains(avatarImages.accessories[0]) {
                    imageStrings.removeAtIndex(2)
                }
            }
        } else if avatarPath == maleOutfitPath {
            imageStrings.append(imageStrings.removeAtIndex(1))
            imageStrings.append(imageStrings.removeAtIndex(2))
            if imageStrings.count == 7 {
                if (imageStrings.contains(avatarImages.hairMale[0]) || imageStrings.contains(avatarImages.hairMale[3])) && imageStrings.contains(avatarImages.accessories[0]){
                    imageStrings.removeLast()
                }
                imageStrings.append(imageStrings.removeAtIndex(4))
                
            }
            imageStrings.append(imageStrings.removeAtIndex(0))
            
        }
        return imageStrings
    }
}