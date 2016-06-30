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
    func readRoom(roomName: String, completion: ([String: AnyObject] -> Void))
    func updateDone(roomName: String, done: [Int])
    func updateTurn(roomName: String, currentSelection: Int, currentPlayer: String, category: String)
    func readRoomOnce(roomName: String, completion: ([String: AnyObject] -> Void))
    func iamready(roomName: String, ready: [String])
    func iamleaving(roomName: String, ready: [String], players: [String])
    func startGame(roomName: String, startTime: Int)
}

extension ModelInterface: FirebaseModelProtocol {
    func updateScore(roomName: String, player: String, newScore: [String]) {
        let ref = FIRDatabase.database().reference()
        ref.child("rooms/\(roomName)/scores/\(player)").setValue(newScore)
        ref.child("rooms/\(roomName)/currentPlayer/").setValue(player)
    }
    
    func readRoom(roomName: String, completion: ([String: AnyObject] -> Void)) {
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
    
    func readRoomOnce(roomName: String, completion: ([String: AnyObject] -> Void)) {
        let ref = FIRDatabase.database().reference()
        ref.child("rooms/\(roomName)/").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            let roomDict = snapshot.value as! [String : AnyObject]
            // ...
            completion(roomDict)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func iamready(roomName: String, ready: [String]) {
        ref.child("rooms/\(roomName)/ready").setValue(ready)
    }
    func iamleaving(roomName: String, ready: [String], players: [String]) {
        ref.child("rooms/\(roomName)/ready").setValue(ready)
        ref.child("rooms/\(roomName)/players").setValue(players)
    }
    func iamleavinggame(roomName: String, ready: [String], players: [String], currentPlayer: String) {
        ref.child("rooms/\(roomName)/ready").setValue(ready)
        ref.child("rooms/\(roomName)/players").setValue(players)
        ref.child("rooms/\(roomName)/currentPlayer").setValue(currentPlayer)
    }
    func startGame(roomName: String, startTime: Int) {
        ref.child("rooms/\(roomName)/startTime").setValue(startTime)
    }
}
