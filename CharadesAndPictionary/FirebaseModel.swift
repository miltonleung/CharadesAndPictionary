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
    func updateScore(roomName: String, player: String, newScore: [String])
    func updateRoom(roomName: String, completion: ([String: AnyObject] -> Void))
    func updateDone(roomName: String, done: [Int])
}

extension ModelInterface: FirebaseModelProtocol {
    func updateScore(roomName: String, player: String, newScore: [String]) {
        let ref = FIRDatabase.database().reference()
        ref.child("rooms/\(roomName)/scores/\(player)").setValue(newScore)
    }
    func updateRoom(roomName: String, completion: ([String: AnyObject] -> Void)) {
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
    func updateTurn(roomName: String, currentSelection: Int, currentPlayer: String, category: String) {
        let ref = FIRDatabase.database().reference()
        ref.child("rooms/\(roomName)/category").setValue("\(category)")
        ref.child("rooms/\(roomName)/currentSelection").setValue(currentSelection)
        ref.child("rooms/\(roomName)/currentPlayer").setValue("\(currentPlayer)")
    }
}
