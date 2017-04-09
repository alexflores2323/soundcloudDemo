//
//  LibraryMenuViewController.swift
//  AudioCloud
//
//  Created by Alex Flores on 3/16/17.
//  Copyright  © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import Firebase

class LibraryMenuViewController: UITableViewController {
    
    let items = ["Saved Music", "Recently Played"]
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
	
	var u: User!
	
	var user: FIRUser!
	var db: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
		let user = FIRAuth.auth()?.currentUser!
		db = FIRDatabase.database().reference()
		db.child("users").child(user!.uid).child("avatar").observeSingleEvent(of: .value, with: {snapshot in
			let urlString = String(describing: snapshot.value!)
			guard let url = URL(string: urlString) else { return }
			URLSession.shared.dataTask(with: url) { (data, response, error) in
				if error != nil {
					print("Failed fetching image: \(error?.localizedDescription)")
					return
				}
				guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
					print("Not a proper HTTPURLResponse or statusCode")
					return
				}
				
				DispatchQueue.main.async {
					self.backgroundImageView.image = UIImage(data: data!)
					self.profilePictureView.image = UIImage(data: data!)
				}
				}.resume()
		})
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profilePictureView.layer.cornerRadius = profilePictureView.frame.width / 2
        profilePictureView.layer.masksToBounds = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryMenuCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var type = ""
        if indexPath.row == 0 {
            type = "save"
        }
        else if indexPath.row == 1 {
            type = "play"
        }
        if let collectionVC = storyboard?.instantiateViewController(withIdentifier: "MusicCollectionVC") as? MusicCollectionViewController {
            collectionVC.type = type
            collectionVC.user = user!
            present(collectionVC, animated: true, completion: nil)
        }
    }
}
