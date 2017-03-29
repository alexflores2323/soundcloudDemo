//
//  MusicCollectionViewController.swift
//  AudioCloud
//
//  Created by Alex Flores on 3/16/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import Parse

class MusicCollectionViewController: UITableViewController {
    
    var type = "play"
    var objects = [PFObject]()
    var user: PFUser?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    
    func fetchData() {
        if let collectionUser = user {
            let query = PFQuery(className: "Activity")
            query.whereKey("user", equalTo: collectionUser)
            query.whereKey("type", equalTo: type)
            if type == "play" {
                query.order(byDescending: "lastPlayed")
            }
            else {
                query.order(byDescending: "createdAt")
            }
            query.includeKey("audio")
            query.findObjectsInBackground(block: { (objects, error) in
                if let theObjects = objects {
                    self.objects = theObjects
                    self.tableView.reloadData()
                }
            })
        }
                
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! SearchCell
        
        let activityObject = objects[indexPath.row]
        if let audioObject = activityObject.object(forKey: "audio") as? PFObject {
            
            if let coverLink = (audioObject.object(forKey: "cover") as? PFFile)?.url {
                if let coverURL = URL(string: coverLink) {
                    cell.coverArtThumbnailView.sd_setImage(with: coverURL)
                }
            }
            cell.titleLabel.text = audioObject.object(forKey: "title") as? String
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
