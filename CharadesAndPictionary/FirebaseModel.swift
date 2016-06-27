//
//  FirebaseModel.swift
//  CharadesAndPictionary
//
//  Created by Milton Leung on 2016-06-26.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseModelProtocol {
    
}

extension ModelInterface: FirebaseModelProtocol {
    func updateScore(roomName: String, player: String, newScore: [String]) {
        let ref = FIRDatabase.database().reference()
        ref.child("rooms/\(roomName)/scores/\(player)").setValue(newScore)
    }
    func updatePlayers(roomName: String, completion: ([String: AnyObject] -> Void)) {
        let ref = FIRDatabase.database().reference()
        ref.child("rooms/\(roomName)/").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let playersDict = snapshot.value as! [String : AnyObject]
            // ...
            completion(playersDict)
        })
    }
    func updateDone(roomName: String, done: [Int]) {
        let ref = FIRDatabase.database().reference()
        ref.child("rooms/\(roomName)/done").setValue(done)
    }
}
