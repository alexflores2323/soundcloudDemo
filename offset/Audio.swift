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
			print("fetching likers")
			let likeQuery = (db.child("activity").queryOrdered(byChild: "audio").queryEqual(toValue: self.autogenKey))
			likeQuery.observeSingleEvent(of: .value, with: { snapshot in
				guard let data = snapshot.value! as? [String: [String: AnyObject]] else {
					completion(0, false, nil)
					return
				}
				let keys = data.keys
				for k in keys {
					if data[k]?["type"] as! String == "like" {
						if let dataUser = data[k]?["user"] as? String {
							self.likers?.append(dataUser)
							if dataUser == currentUser.uid {
								self.isLikedByCurrentUser = true
							}
						}
					}
				}
				self.likes = (self.likers?.count)!
				completion(self.likes, self.isLikedByCurrentUser, nil)
			})

		}
		else { completion(likes, isLikedByCurrentUser, nil) }
	}
    
}
