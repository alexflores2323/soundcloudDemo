//
//  NowPlayingViewController.swift
//  AudioCloud
//
//  Created by Alex Flores on 3/17/17.
//  Copyright  © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class NowPlayingViewController: UIViewController {
    
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageview: UIImageView!
    @IBOutlet var tapCover: UITapGestureRecognizer!
    @IBOutlet weak var blurView: UIVisualEffectView!
	
	var object: [String: String]?
	
    var player: AVPlayer?
    
    var isPlaying = false
	
	var db: FIRDatabaseReference!
	
	var user: FIRUser!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		user = (FIRAuth.auth()?.currentUser)!
		
		db = FIRDatabase.database().reference()
		
		if let obj = object {
			if let coverLink = obj["cover"] {
				if let coverURL = URL(string: coverLink) {
					setCoverImage(coverURL)
				}
			}
			self.usernameButton.setTitle(user.email, for: .normal)
			titleLabel.text = obj["title"]
		}
		
    }
	
	func setCoverImage(_ fromURL: URL) {
		URLSession.shared.dataTask(with: fromURL) { (data, response, error) in
			if error != nil {
				print("Failed fetching image: \(error?.localizedDescription)")
				return
			}
			guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
				print("Not a proper HTTPURLResponse or statusCode")
				return
			}
			DispatchQueue.main.async {
				self.coverImageview.image = UIImage(data: data!)
			}
		}.resume()
	}
	
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		let dataPath = "users/\(user.uid)/lastPlayed"
		db.child(dataPath).observeSingleEvent(of: .value, with: {snapshot in
			if let lastPlayed = snapshot.value! as? [String: String] {
				if self.object == nil {
					let last = ["title": lastPlayed["title"], "cover": "url"]
					//self.object?.updateValue(lastPlayed["cover"]!, forKey: "cover")
					self.object?.updateValue(lastPlayed[""]!, forKey: "cover")
				}
				else {
					self.db.child(dataPath).setValue(["title": lastPlayed["title"], "cover": lastPlayed["cover"]])
				}
				self.playAudio()
			}
		})
//        if let currentUser = PFUser.current(), let audioObject = object {
//			// get the song playing data for this user
//            let query = PFQuery(className: "Activity")
//            query.whereKey("user", equalTo: currentUser)
//            query.whereKey("audio", equalTo: audioObject)
//            query.whereKey("type", equalTo: "play")
//            query.findObjectsInBackground(block: { (objects, error) in
//                if let theError = error {
//                    print("???????? \(theError)")
//                }
//				
//                else if let theObjects = objects {
//					// if we don't have any yet, make a song object
//                    if theObjects.count == 0 {
//                        let activityObject = PFObject(className: "Activity")
//                        activityObject.setObject(currentUser, forKey: "user")
//                        activityObject.setObject(audioObject, forKey: "audio")
//                        activityObject.setObject("play", forKey: "type")
//                        activityObject.setObject(Date(), forKey: "lastPlayed")
//                        activityObject.saveEventually()
//                    }
//                    else {
//						// otherwise get the last song object stored
//                        let activityObject = theObjects.first
//                        activityObject?.setObject(Date(), forKey: "lastPlayed")
//                        activityObject?.saveEventually()
//                    }
//                }
//            })
//        }
        playAudio()
        
    }

	@IBAction func dismissButtonPressed(_ sender: UIButton) {
			dismiss(animated: true, completion: nil)
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func tappedCover(_ sender: UITapGestureRecognizer) {
        if isPlaying {
            player?.pause()
        }
        else {
            player?.play()
        }
        isPlaying = !isPlaying
        blurView.isHidden = isPlaying
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
		if let obj = object {
			guard let u = user else {
				return
			}
			let key = db.child("activity").childByAutoId().key
			db.child("activity").child(key).setValue(["audio": obj["audio"], "user": u.uid, "type": "save", "createdAt": String(describing: Date())])

		}
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
		// share the song via activity controller?
		if let audioURL = object?["soundfile"] {
			let shareText = "Check out my new song: \(audioURL)"
			let activityController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
			present(activityController, animated: true, completion: nil)
		}
	//        if let songLink = (object?.object(forKey: "audioFile") as? PFFile)?.url {
	//            let shareText = "Check out my new song: \(songLink)"
	//            let activityController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
	//            present(activityController, animated: true, completion: nil)
	//
	//        }
    }
    
    
    func playAudio() {
		// see if we find the file url
		guard let audioURLString = object?["audioFile"] else {
			print("no audio url found")
			return
		}
		guard audioURLString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) != nil else {
			print("no audio url found")
			return 
		}
		guard let audioURL = URL(string: audioURLString) else {
			print("URL creation not working")
			return
		}
		let playerItem = AVPlayerItem(url: audioURL)
		player = AVPlayer(playerItem: playerItem)
		player?.play()
		isPlaying = true
    }

    
}













