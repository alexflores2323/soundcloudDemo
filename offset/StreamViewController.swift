//
//  StreamViewController.swift
//  AudioCloud
//
//  Created by Alex Flores on 3/16/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import Parse
import SDWebImage

class StreamViewController: UITableViewController, StreamCellDelegate {
    
    var audioObjects = [Audio]()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.delegate = self
        if let user = object.object(forKey: "user") as? PFUser {
            cell.usernameLabel.text = user.username
            if let profilePictureURLString = (user.object(forKey: "ava") as? PFFile)?.url  {
                if let profilePicURL = URL(string: profilePictureURLString) {
                    cell.profilePictureView.sd_setImage(with: profilePicURL)
                }
            }
        }
        cell.captionLabel.text = object.object(forKey: "description") as? String
        if let length = object.object(forKey: "length") as? NSNumber {
            cell.musicLengthLabel.text = length.stringValue
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        if let postedDate = object.createdAt {
            cell.timeLabel.text = formatter.string(from: postedDate)
        }
        
        if let coverArtPath = (object.object(forKey: "cover") as? PFFile)?.url {
            if let coverArtURL = URL(string: coverArtPath) {
                cell.coverArtImageView.sd_setImage(with: coverArtURL)
            }
        }
        cell.fetchLikeData()

        return cell
    }
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = audioObjects[indexPath.row].object
        if let nowPlayingVC = storyboard?.instantiateViewController(withIdentifier: "NowPlayingVC") as? NowPlayingViewController {
            nowPlayingVC.object = object
            present(nowPlayingVC, animated: true, completion: nil)
        }
    }
    
    
    
    func loadData() {
        let query = PFQuery(className: "Audio")
        query.includeKey("user")
        query.findObjectsInBackground { (objects, error) in
            if let theObjects = objects {
                self.audioObjects.removeAll()
                for object in theObjects {
                    self.audioObjects.append(Audio(object: object))
                }
                self.tableView.reloadData()
            }
            else if let theError = error {
                print("what the hell : \(theError)")
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    func streamCell(cell: StreamCell, didSelecteViewProfileButtonForUser user: PFUser) {
        if let profileVC = storyboard?.instantiateViewController(withIdentifier: "bottom") as? LibraryMenuViewController {
            profileVC.user = user
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    

    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
