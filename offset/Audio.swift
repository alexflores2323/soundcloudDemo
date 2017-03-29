//
//  Audio.swift
//  AudioCloud
//
//  Created by Alex Flores on 3/20/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import Parse

class Audio: NSObject {
    
    var isLikedByCurrentUser = false
    var likes = 0
    var likers: [PFUser]?
    var object: PFObject
    
    init(object: PFObject) {
        self.object = object
        super.init()
    }
    
    func fetchLikersData(completion: @escaping (Int, Bool, Error?) -> Void) {
        if likers == nil {
            guard let currentUser = PFUser.current() else {
                print("no user logged in")
                return
            }
            let query = PFQuery(className: "Activity")
            query.whereKey("audio", equalTo: object)
            query.whereKey("type", equalTo: "like")
            query.findObjectsInBackground { (objects, error) in
                if let theObjects = objects {
                    self.likes = theObjects.count
                    self.likers = [PFUser]()
                    for aObject in theObjects {
                        if let user = aObject.object(forKey: "user") as? PFUser {
                            self.likers?.append(user)
                            if user.objectId == currentUser.objectId {
                                self.isLikedByCurrentUser = true
                            }
                        }
                    }
                    completion(self.likes, self.isLikedByCurrentUser, nil)
                    
                }
                else {
                    completion(0, false, error)
                }
            }
        }
        else {
            completion(likes, isLikedByCurrentUser, nil)
        }
        
    }
    
}
