//
//  StreamCell.swift
//  AudioCloud
//
//  Created by Alex Flores on 3/16/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import Firebase

class StreamCell: UITableViewCell {

    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var coverArtImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var musicLengthLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var likeCount = 0
    var isLikedByCurrentUser = false
		
	var likers: [String]?
	
	var object: AnyObject?
	
    var delegate: StreamCellDelegate?
	
	var user: FIRUser?
	
	var db: FIRDatabaseReference!
	
	var audioKey: String!
    
    override func layoutSubviews() {
        super.layoutSubviews()
		user = FIRAuth.auth()?.currentUser!
		db = FIRDatabase.database().reference()
        profilePictureView.layer.cornerRadius = profilePictureView.frame.width / 2
        profilePictureView.layer.masksToBounds = true
    }
    
    @IBAction func viewProfileButtonPressed(_ sender: UIButton) {
		if let currentUser = user {
			delegate?.streamCell(cell: self, didSelecteViewProfileButtonForUser: currentUser)
		}
//        if let theUser = object?.object(forKey: "user") as? PFUser {
//            delegate?.streamCell(cell: self, didSelecteViewProfileButtonForUser: theUser)
//        }
    }
    
    func fetchLikeData() {
        if likers == nil {
            likeButton.isHidden = true
            guard let audioObject = object else {
                print("no audio object")
                return
            }
            guard let currentUser = FIRAuth.auth()?.currentUser else {
                print("no user logged in")
                return
            }
//            let query = PFQuery(className: "Activity")
//            query.whereKey("user", equalTo: currentUser)
//            query.whereKey("audio", equalTo: audioObject)
//            query.whereKey("type", equalTo: "like")
//            query.cachePolicy = PFCachePolicy.cacheElseNetwork
//            query.findObjectsInBackground { (objects, error) in
//                if let theObjects = objects {
//                    if theObjects.count > 0 {
//                        self.likeButton.isSelected = true
//                        
//                    }
//                    else {
//                        self.likeButton.isSelected = false
//                        
//                    }
//                    self.likeButton.isHidden = false
//                    
//                }
//            }
        }
        else {
            likeButton.isSelected = isLikedByCurrentUser
        }
        
    }

    @IBAction func likeButtonPressed(_ sender: UIButton) {
        guard let audioObject = object else {
            print("no audio object")
            return
        }
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            print("no user logged in")
            return
        }
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
			let key = db.child("activity").childByAutoId().key
			db.child("activity").child(key).setValue(["audio": audioKey, "user": currentUser.uid, "createdAt": String(describing: Date()), "type": "like" ])
        }
        
        else {
			let query = (db.child("activity").queryOrderedByValue().queryEqual(toValue: "user", childKey: currentUser.uid))
			query.observeSingleEvent(of: .value, with: {snapshot in
				if let data = snapshot.value! as? [String: [String: String]] {
					for k in data.keys {
						if data[k]?["type"] == "like" {
							self.db.child("activity").child(k).removeValue()
						}
					}
				}
			})
			print(query)
        }
        
    }
}

protocol StreamCellDelegate {
    func streamCell(cell: StreamCell, didSelecteViewProfileButtonForUser user: FIRUser)
}
