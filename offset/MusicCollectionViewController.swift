//
//  MusicCollectionViewController.swift
//  AudioCloud
//
//  Created by Alex Flores on 3/16/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import Firebase
class MusicCollectionViewController: UITableViewController {
    
    var type = "play"
	
	var db: FIRDatabaseReference!
	
	var dataObjects: [AnyObject]!

	var user: FIRUser!
	
	var uid: String!
	
	@IBAction func backNavClick(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func clearNavClick(_ sender: Any) {
		let alert = UIAlertController(title: "Naw Jk", message: "Can't actually clear, lol", preferredStyle: UIAlertControllerStyle.alert)
		let ok = UIAlertAction(title: "... Okay", style: UIAlertActionStyle.default, handler: nil)
		alert.addAction(ok)
		self.present(alert, animated: true, completion: nil)
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		user = FIRAuth.auth()?.currentUser!
		
		db = FIRDatabase.database().reference()
		
		dataObjects = [AnyObject]()
		
		print("going to fetch the data")
		
		fetchData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObjects.count
    }
    
    
    func fetchData() {
        if let collectionUser = user {
			print("collection user id passed")
			//var playedData = [[String: AnyObject]]()
			//let id = collectionUser.uid
//			db.child("users").child(id).child("plays").observeSingleEvent(of: .value, with: { snapshot in
//				if let played = snapshot.value as? [String: AnyObject] {
//					let allKeys = played.keys
//					for k in allKeys {
//						let thisItem = [
//							"createdAt": played[k]?["lastPlayed"] as AnyObject,
//							"audio": played[k]?["audio"] as AnyObject,
//							"user": collectionUser.uid as AnyObject
//						]
//						self.dataObjects.append(thisItem as AnyObject)
//					}
//				}
//			})
	
			let query = (db.child("activity").queryOrdered(byChild: "audio"))
			print(query)
			query.observeSingleEvent(of: .value, with: {snapshot in
				print(snapshot.value!)
				if let data = snapshot.value! as? [String: AnyObject] {
					for k in data.keys {
						if data[k]?["type"] as! String == "play" {
							self.dataObjects.append(data[k] as AnyObject)
						}
					}
					self.tableView.reloadData()
				}
			})
        }
                
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! SearchCell
        let activityObject = dataObjects[indexPath.row]
		
		if let audioKey = activityObject["audio"] as? String {
			db.child("songs").child(audioKey).observeSingleEvent(of: .value, with: {snapshot in
				print(snapshot.value!)
				if let audioObject = snapshot.value! as? [String: AnyObject] {
					if let coverLink = audioObject["cover"] as? String {
						if let coverURL = URL(string: coverLink) {
							cell.coverArtThumbnailView.sd_setImage(with: coverURL)
						}
					}
					cell.titleLabel.text = (audioObject["description"] as! String)
				}
			})
		}
        return cell
    }
  

}
