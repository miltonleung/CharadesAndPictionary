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

let defaultAvatar = ["MaleBrownSkin", "MaleYeezy", "Grey950s", "MaleBrownHead", "MaleBrownBuzz", "Snapback", "BlackEyesFace"]

let womenOutfitPath = [avatarImages.faceWomen, avatarImages.skinWomen, avatarImages.hairWomen, avatarImages.topWomen, avatarImages.shoesWomen]

let womenTPath = [avatarImages.faceWomen, avatarImages.skinWomen, avatarImages.hairWomen, avatarImages.topWomen, avatarImages.pantsWomen, avatarImages.shoesWomen]

let maleTPath = [avatarImages.faceMale, avatarImages.skinMale, avatarImages.hairMale, avatarImages.topMale, avatarImages.topColor, avatarImages.pantsMale, avatarImages.shoesMale, avatarImages.accessories]

let maleOutfitPath = [avatarImages.faceMale, avatarImages.skinMale, avatarImages.hairMale, avatarImages.topMale, avatarImages.shoesMaleOutfit, avatarImages.accessories]

let avatarPaths = [womenOutfitPath, womenTPath, maleTPath, maleOutfitPath]

enum ErrorMessages {
    static let emptyName = "Please enter a name"
    static let emptyRoom = "Please enter a room name"
    static let symbols = "Please refrain from using # [ ] * ? . or $"
}

enum avatarType {
    static let gender:Int = 0
    static let skinColor = 1
    static let hair = 2
    static let top = 3
    static let topColor = 4
    static let pants = 5
    static let shoes = 6
    static let accessories = 7
}

enum avatarImages {
    static let faceMale = ["BlackEyesFace"]
    static let faceWomen = ["BlackEyesFace"]
    static let skinMale = ["MaleBrownSkin", "MaleBlackSkin", "MaleWhiteSkin"]
    static let skinWomen = ["WomenWhiteSkin", "WomenTanSkin"]
    static let headMale = ["MaleBrownHead", "MaleBlackHead", "MaleWhiteHead"]
    static let skinColorMale = ["MaleBrownFace", "MaleDBrownFace", "MaleWhiteFace"]
    static let skinColorWomen = ["WomenWhiteFace", "WomenTanFace"]
    static let hairMale = ["MaleBrownHair", "MaleBrownBuzz", "MaleDBrownBuzz", "MaleDBrownHair"]
    static let hairWomen = ["WomenLongDBrownHair", "WomenLongBlackHair", "WomenBrownBangs", "WomenLongBrownHair"]
    static let topMale = ["MaleIanConner", "MaleRagsOutfit", "MaleRedT", "MaleYeezy"]
    static let topWomen = ["WomenBlueSundress", "WomenNYTank", "WomenVeniceTank", "WomenRedSundress"]
    static let topColor = ["MaleRedT", "MaleGreenT", "MaleWhiteT"]
    static let pantsMale = ["MaleBlueJeans", "MaleBlueShorts"]
    static let pantsWomen = ["WomenBlackShortShorts", "WomenBlueShortShorts"]
    static let shoesMale = ["BlueFlats", "WhiteFlats"]
    static let shoesMaleOutfit = ["Grey750s", "Grey950s", "Tan950s"]
    static let shoesWomen = ["WhiteFlats", "BlueFlats"]
    static let accessories = ["Trucker", "Snapback"]
    
}

enum previewAvatar {
    static let male = ["MaleBrownSkinSmall", "YeezyOutfitSmall", "MaleBrownHeadSmall", "MaleBrownHairSmall", "BlackEyesFaceSmall", "Grey950Small"]
    static let female = ["WomenTanSkinSmall", "WomenBrownHairSmall", "BlackEyesFaceSmall", "WomenRedSundressSmall", "WhiteFlatsSmall"]
    static let skinColorMale = ["MaleBrownFaceSmall", "MaleDBrownFaceSmall", "MaleWhiteFaceSmall"]
    static let skinColorWomen = ["WomenWhiteFaceSmall", "WomenTanFaceSmall"]
    static let hairMale = ["MaleBrownBuzzSmall", "MaleDBrownBuzzSmall", "MaleBrownHairSmall", "MaleDBrownHairSmall",]
    static let hairWomen = ["WomenLongDBrownHairSmall", "WomenLongBlackHairSmall", "WomenBrownBangsSmall", "WomenLongBrownHairSmall"]
    static let topMale = ["MaleIanConnerSmall", "MaleYeezySmall", "MaleRagsSmall", "MaleRedTSmall"]
    static let topWomen = ["WomenBlueSundressSmall", "WomenRedSundressSmall", "WomenNYTankSmall", "WomenVeniceTankSmall"]
    static let topColor = ["MaleGreenTSmall", "MaleRedTSmall", "MaleWhiteTSmall"]
    static let pantsMale = ["MaleBlueJeansSmall", "MaleBlueShortsSmall"]
    static let pantsWomen = ["WomenBlackShortShortsSmall", "WomenBlueShortShortsSmall"]
    static let shoesMale = ["Grey750sSmall", "BlueFlatsSmall", "Grey950sSmall", "Tan950sSmall"]
    static let shoesMaleOutfit = ["Grey750sSmall", "Grey950sSmall", "Tan950sSmall"]
    static let shoesWomen = ["WhiteFlatsSmall", "BlueFlatsSmall"]
    static let accessories = ["TruckerSmall", "SnapbackSmall"]
}

var badCharacters: Set<Character> = ["#", "[", "]", "*", "?", ".", "$"]