//
//  Audio.swift
//  AudioCloud
//
//  Created by Alex Flores on 3/20/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import Firebase

class Audio: NSObject {
    
	var isLikedByCurrentUser: Bool
	var likes: Int
	var likers: [String]?
	var object: AnyObject
	var autogenKey: String!
	var db: FIRDatabaseReference!
	
	init(object: AnyObject, key: String) {
		self.db = FIRDatabase.database().reference()
        self.object = object
		self.autogenKey = key
		self.isLikedByCurrentUser = false
		self.likes = 0
        super.init()
    }
	
	func fetchLikersData(completion: @escaping (Int, Bool, Error?) -> Void) {
	
		if likers == nil {
			self.likers = [String]()
			guard let currentUser = FIRAuth.auth()?.currentUser
				else { return }
			db.child("songs").child(autogenKey).observeSingleEvent(of: .value, with: {(snapshot) in
				let data = snapshot.value! as! [String: Any]
				if let likeData = data["likers"] as? [String: String] {
					let keys = likeData.keys
					for k in keys {
						self.likers!.append(likeData[k]!)
						if likeData[k]! == currentUser.uid {
							self.isLikedByCurrentUser = true
						}
					}
					self.likes = self.likers!.count
					completion(self.likes, self.isLikedByCurrentUser, nil)
				}
				else {
					completion(0, false, nil)
				}
			})
		}
		else { completion(likes, isLikedByCurrentUser, nil) }
	}
    
    /*func fetchLikersData(completion: @escaping (Int, Bool, Error?) -> Void) {
        if likers == nil {
            guard let currentUser = FIRAuth.auth()?.currentUser else {
                print("no user logged in")
                return
            }
			let activity = ["audio" : ["title": "", "cover": ""]]
//            let query = PFQuery(className: "Activity")
//            query.whereKey("audio", equalTo: object)
//            query.whereKey("type", equalTo: "like")
//            query.findObjectsInBackground { (objects, error) in
//                if let theObjects = objects {
//                    self.likes = theObjects.count
//                    self.likers = [FIRUser]()
//                    for aObject in theObjects {
//                        if let user = aObject.object(forKey: "user") as? FIRUser {
//                            self.likers?.append(user)
//                            if user.uid == currentUser.uid {
//                                self.isLikedByCurrentUser = true
//                            }
//                        }
//                    }
//                    completion(self.likes, self.isLikedByCurrentUser, nil)
//                    
//                }
//                else {
//                    completion(0, false, error)
//                }
//            }
        }
        else {
            completion(likes, isLikedByCurrentUser, nil)
        }
        
    }*/
    
}
