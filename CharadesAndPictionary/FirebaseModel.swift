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
    func updateDone(roomName: String, done: [Int], category: String)
    func updateTurn(roomName: String, currentSelection: Int, currentPlayer: String, category: String)
    func readRoomOnce(roomName: String, completion: ([String: AnyObject] -> Void))
    func iamready(roomName: String, ready: [String])
    func iamleaving(roomName: String, ready: [String], players: [String])
    func startGame(roomName: String, startTime: Int)
    func removeListener(roomName: String)
    func makeRoom(roomName: String, authors: [String], icon: String, description: String, publicOrPrivate: String)
}

extension ModelInterface: FirebaseModelProtocol {
    func readCategories(completion: ([String: AnyObject] -> Void)) {
        let categoriesRef = ref.child("modules/public/")
        categoriesRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let categories = snapshot.value as! [String: AnyObject]
            completion(categories)
        })
        
    }
    
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
    
    func updateDone(roomName: String, done: [Int], category: String) {
        let ref = FIRDatabase.database().reference()
        ref.child("rooms/\(roomName)/done").child(category).setValue(done)
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
    func removeListener(roomName: String) {
        ref.child("rooms/\(roomName)").removeAllObservers()
    }
    func makeRoom(roomName: String, authors: [String], icon: String, description: String, publicOrPrivate: String) {
        let key = ref.child("modules/community/\(publicOrPrivate)/\(roomName)").childByAutoId().key
        ref.child("modules/community/\(publicOrPrivate)/\(roomName)").setValue(
            [   "icon": icon,
                "author": authors,
                "description": description,
                "list": key])
        
        //        ref.child("modules/community/lists/\(key)").setValue(["Threat Level Midnight"])
    }
    func fetchLists(completion: ([String: AnyObject] -> Void)) {
        ref.child("modules/community/public").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let playersDict = snapshot.value as! [String : AnyObject]
            // ...
            completion(playersDict)
        })
    }
    func addToList(listName: String, entry: String) {
        ref.child("modules/community/lists/\(listName)").runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            var entries = currentData.value as? [String]
            if entries == nil {
                entries = [String]()
            }
            entries!.append(entry)
            
            currentData.value = entries
            
            return FIRTransactionResult.successWithValue(currentData)
            
            
        }) {( error, commited, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func fetchSingleList(listKey: String, completion: ([String] -> Void)) {
        ref.child("modules/community/lists/\(listKey)").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let list = snapshot.value as! [String]
            // ...
            completion(list)
        })
    }
}
