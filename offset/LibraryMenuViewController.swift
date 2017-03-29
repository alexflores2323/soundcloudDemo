//
//  LibraryMenuViewController.swift
//  AudioCloud
//
//  Created by Alex Flores on 3/16/17.
//  Copyright  © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import Parse

class LibraryMenuViewController: UITableViewController {
    
    let items = ["Saved Music", "Recently Played"]
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!

    var user: PFUser?

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            user = PFUser.current()
        }
        user?.fetchIfNeededInBackground(block: { (object, error) in
            if let fetchedUser = object as? PFUser {
                if let profilePicLink = (fetchedUser.object(forKey: "ava") as? PFFile)?.url {
                    if let profilePicURL = URL(string: profilePicLink) {
                        self.backgroundImageView.sd_setImage(with: profilePicURL)
                        self.profilePictureView.sd_setImage(with: profilePicURL)
                    }
                }
                self.usernameLabel.text = fetchedUser.username
            }
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
            collectionVC.user = user
            present(collectionVC, animated: true, completion: nil)
        }
    }
}
