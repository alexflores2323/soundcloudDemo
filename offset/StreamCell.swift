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
	
	//var likers: [FIRUser]?
	
	var likers: [String]?
	
	var object: Audio!
	
    var delegate: StreamCellDelegate?
	
	var user: User!
	
	var db = FIRDatabase.database().reference().child("activity")
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePictureView.layer.cornerRadius = profilePictureView.frame.width / 2
        profilePictureView.layer.masksToBounds = true
    }
    
    @IBAction func viewProfileButtonPressed(_ sender: UIButton) {
		delegate?.streamCell(cell: self, didSelecteViewProfileButtonForUser: user)
    }
    
    func fetchLikeData() {
        if likers == nil {
            likeButton.isHidden = true
            guard let audioObject = object else {
                print("no audio object")
                return
            }
//            guard let currentUser = FIRAuth.auth()?.currentUser else {
//                print("no user logged in")
//                return
//            }
			let query = (db.queryOrderedByKey().queryEqual(toValue: "like", childKey: "type"))
			query.observeSingleEvent(of: .value, with: {(snapshot) in
				print(snapshot.value!)
			})
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
//            let activityObject = PFObject(className: "Activity")
//            activityObject.setObject(audioObject, forKey: "audio")
//            activityObject.setObject(currentUser, forKey: "user")
//            activityObject.setObject("like", forKey: "type")
//            activityObject.saveEventually()
        }
        
        else {
//            let query = PFQuery(className: "Activity")
//            query.whereKey("user", equalTo: currentUser)
//            query.whereKey("audio", equalTo: audioObject)
//            query.whereKey("type", equalTo: "like")
//            query.getFirstObjectInBackground(block: { (likeObject, error) in
//                likeObject?.deleteEventually()
//            })
        }
        
    }
}

protocol StreamCellDelegate {
    func streamCell(cell: StreamCell, didSelecteViewProfileButtonForUser user: User)
}
