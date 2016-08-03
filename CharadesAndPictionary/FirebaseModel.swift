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
    func readCategories(completion: ([String: AnyObject] -> Void))
    func checkForRoom(completion: [String: AnyObject] -> Void)
    func addPlayer(roomName: String) -> String
    func updateScore(roomName: String, player: String, newScore: [String])
    func readRoom(roomName: String, completion: ([String: AnyObject] -> Void))
    func updateDone(roomName: String, done: [Int], category: String)
    func updateTurn(roomName: String, currentSelection: Int, currentPlayer: String, category: String)
    func readRoomOnce(roomName: String, completion: ([String: AnyObject] -> Void))
    func iamready(roomName: String, ready: [String])
    func iamleaving(roomName: String, ready: [String])
    func iamleavinggame(roomName: String, ready: [String], currentPlayer: String)
    func startGame(roomName: String, startTime: Int)
    func removeListener(roomName: String)
    func makeRoom(roomName: String, authors: [String], icon: String, description: String, publicOrPrivate: String)
    func fetchLists(completion: ([String: AnyObject] -> Void))
    func addToList(listName: String, entry: String)
    func addToCount(listName: String)
    func fetchSingleList(listKey: String, completion: ([String] -> Void))
    func fetchListCount(listName: String, completion: (Int -> Void))
    func addRoom(editedText: String, password: String)
    
}

extension ModelInterface: FirebaseModelProtocol {
    func readCategories(completion: ([String: AnyObject] -> Void)) {
        let categoriesRef = ref.child("modules/public/")
        categoriesRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            if let categories = snapshot.value as? [String: AnyObject] {
                completion(categories)
            }
        })
        
    }
    
    func checkForRoom(completion: [String: AnyObject] -> Void) {
        let roomPath = ref.child("rooms")
        roomPath.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            if let roomData = snapshot.value as? [String: AnyObject] {
                completion(roomData)
            } else {
                completion([String: AnyObject]())
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addPlayer(roomName: String) -> String{
        let key = ref.child("rooms/\(roomName)/players").childByAutoId().key
        let avatarImage = myAvatarImage as! AnyObject
        let player = [myName: avatarImage]
        ref.updateChildValues(["/rooms/\(roomName)/players/\(key)": player])
        return key
    }
    
    func updateScore(roomName: String, player: String, newScore: [String]) {
        let ref = FIRDatabase.database().reference()
        ref.child("rooms/\(roomName)/scores/\(player)").setValue(newScore)
        ref.child("rooms/\(roomName)/currentPlayer/").setValue(player)
    }
    
    func readRoom(roomName: String, completion: ([String: AnyObject] -> Void)) {
        let ref = FIRDatabase.database().reference()
        ref.child("rooms/\(roomName)/").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            if let playersDict = snapshot.value as? [String : AnyObject] {
                completion(playersDict)
            }
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
    func iamleaving(roomName: String, ready: [String]) {
        ref.child("rooms/\(roomName)/ready").setValue(ready)
        ref.child("rooms/\(roomName)/players/\(myPlayerKey!)").removeValue()
        print(myPlayerKey)
    }
    func iamleavinggame(roomName: String, ready: [String],currentPlayer: String) {
        ref.child("rooms/\(roomName)/ready").setValue(ready)
        ref.child("rooms/\(roomName)/players/\(myPlayerKey!)").removeValue()
        ref.child("rooms/\(roomName)/currentPlayer").setValue(currentPlayer)
    }
    func iamleavinggame(roomName: String, ready: [String]) {
        ref.child("rooms/\(roomName)/ready").setValue(ready)
        ref.child("rooms/\(roomName)/players/\(myPlayerKey!)").removeValue()
        ref.child("rooms/\(roomName)/currentPlayer").removeValue()
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
    }
    func fetchLists(completion: ([String: AnyObject] -> Void)) {
        ref.child("modules/community/public").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            if let playersDict = snapshot.value as? [String : AnyObject] {
                completion(playersDict)
            }
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
    func addToCount(listName: String) {
        ref.child("modules/community/public/\(listName)/count").runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            var count = currentData.value as? Int
            if count == nil {
                count = 0
            }
            count = count! + 1
            
            currentData.value = count
            
            return FIRTransactionResult.successWithValue(currentData)
            
            
        }) {( error, commited, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func fetchSingleList(listKey: String, completion: ([String] -> Void)) {
        ref.child("modules/community/lists/\(listKey)").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            if let list = snapshot.value as? [String] {
                // ...
                completion(list)
            }
        })
    }
    func fetchListCount(listName: String, completion: (Int -> Void)) {
        ref.child("modules/community/public/\(listName)/count").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            if let listCount = snapshot.value as? Int {
                // ...
                completion(listCount)
            }
        })
    }
    func addRoom(editedText: String, password: String) {
        ref.child("rooms/\(editedText)/password").setValue(password)
        ref.child("rooms/\(editedText)/currentPlayer").setValue("\(myName)")
        ref.child("rooms/\(editedText)/startTime").setValue("\(0)")
        ref.child("rooms/\(editedText)/leader").setValue("\(myName)")
    }
    func setLeader(editedText:String, name: String) {
        ref.child("rooms/\(editedText)/leader").setValue("\(name)")
    }
    func removeLeader(roomName: String) {
        ref.child("rooms/\(roomName)/leader").removeValue()
    }
}
