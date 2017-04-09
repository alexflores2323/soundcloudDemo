//
//  StreamViewController.swift
//  AudioCloud
//
//  Created by Alex Flores on 3/16/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class StreamViewController: UITableViewController, StreamCellDelegate {
    
    var audioObjects = [Audio]()
	
	var audioKeys = [String]()
	
	var db: FIRDatabaseReference!
	
	var user: FIRUser!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		db = FIRDatabase.database().reference()
		
		user = (FIRAuth.auth()?.currentUser)!
		
        loadData()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioObjects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamCell", for: indexPath) as! StreamCell
        let audio = audioObjects[indexPath.row]
        
        cell.likeButton.isHidden = true
        audio.fetchLikersData { (likes, isLiked, error) in
            if error == nil {
                cell.likeButton.isHidden = false
                cell.likeButton.isSelected = isLiked
            }
        }
		
        
        let object = audio.object
		
        cell.object = object
		cell.audioKey = audio.autogenKey
		
        cell.delegate = self
	
        cell.captionLabel.text = object["title"] as! String
		cell.musicLengthLabel.text = (object["length"] as! String).uppercased()
		let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        if let postedDate = object["createdAt"] as? String {
            cell.timeLabel.text = postedDate
        }
		let coverURL = URL(string:  object["cover"] as! String)
		URLSession.shared.dataTask(with: coverURL!) { (data, response, error) in
			if error != nil {
				print("Failed fetching image: \(error?.localizedDescription)")
				return
			}
			guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
				print("Not a proper HTTPURLResponse or statusCode")
				return
			}
			
			DispatchQueue.main.async {
				cell.coverArtImageView.image = UIImage(data: data!)
			}
		}.resume()
        cell.fetchLikeData()

        return cell
    }
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = audioObjects[indexPath.row].object
        if let nowPlayingVC = storyboard?.instantiateViewController(withIdentifier: "NowPlayingVC") as? NowPlayingViewController {
            nowPlayingVC.object = object as? [String : String]
			if nowPlayingVC.object != nil {
				present(nowPlayingVC, animated: true, completion: nil)
			}
        }
    }
    
    func loadData() {
		db.child("activity").observeSingleEvent(of: .value, with: { (snapshot) in
			if let data = snapshot.value! as? [String: AnyObject] {
				for k in data.keys {
					let act = data[k] as? [String: AnyObject]
					let key = act!["audio"] as! String
					self.audioKeys.append(key)
					
				}
				
			}
		})
		db.child("songs").observeSingleEvent(of: .value, with: { (snapshot) in
			let data = snapshot.value! as? [String: AnyObject]
			if self.audioKeys.count > 0 {
				self.audioObjects.removeAll()
				var index = 0
				self.audioKeys.forEach({(key) in
					self.audioObjects.append(Audio(object: data![key]!, key: self.audioKeys[index]))
					index = index + 1
				})
			}
			self.tableView.reloadData()
			self.refreshControl?.endRefreshing()
		})
    }
    
    
    func streamCell(cell: StreamCell, didSelecteViewProfileButtonForUser user: FIRUser) {
        if let profileVC = storyboard?.instantiateViewController(withIdentifier: "bottom") as? LibraryMenuViewController {
            profileVC.user = FIRAuth.auth()?.currentUser!
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    


}
