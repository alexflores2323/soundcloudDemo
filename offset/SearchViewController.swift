//
//  SearchViewController.swift
//  offset
//
//  Created by Logan Caracci on 3/20/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
	var db: FIRDatabaseReference!
	
    var objects = [AnyObject]()
	
	var user: FIRUser!
	
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		user = FIRAuth.auth()?.currentUser!
		
		db = FIRDatabase.database().reference()

        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        searchBar.autocorrectionType = UITextAutocorrectionType.no
        searchBar.placeholder = "Search music"

        
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return objects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let object = objects[indexPath.row]
        
        // for the little circle pic in the search cell DO THIS....
        if let coverLink = object.object(forKey: "cover") as? String {
            if let coverURL = URL(string: coverLink) {
				URLSession.shared.dataTask(with: coverURL) { (data, response, error) in
					if error != nil {
						print("Failed fetching image: \(String(describing: error?.localizedDescription))")
						return
					}
					guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
						print("Not a proper HTTPURLResponse or statusCode")
						return
					}
					
					DispatchQueue.main.async {
						cell.coverArtThumbnailView.image = UIImage(data: data!)
					}
				}.resume()
            }
		}
		let user = FIRAuth.auth()?.currentUser
		db.child("users").child((user?.uid)!).child("avatar").observeSingleEvent(of: .value, with: {snapshot in
			let urlString = String(describing: snapshot.value!)
			guard let url = URL(string: urlString) else { return }
			URLSession.shared.dataTask(with: url) { (data, response, error) in
				if error != nil {
					print("Failed fetching image: \(String(describing: error?.localizedDescription))")
					return
				}
				guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
					print("Not a proper HTTPURLResponse or statusCode")
					return
				}
				
				DispatchQueue.main.async {
					//self.profilePictureView.image = UIImage(data: data!)
				}
				}.resume()
		})
		
        // for the title next to to LITTLE CIRCLE PIC DO THIS....
        cell.titleLabel.text = object.object(forKey: "title") as? String
        

        return cell
    }
    
    
    
    
    
    
    
    
    
    func searchFiles(searchTerm: String) {
        
//        let KeywordQuery = PFQuery(className: "Audio")
//        KeywordQuery.whereKey("searchItems", equalTo: searchTerm)
//        
//        let titleQuery = PFQuery(className: "Audio")
//        titleQuery.whereKey("title", equalTo: searchTerm)
//        
//        let query = PFQuery.orQuery(withSubqueries: [KeywordQuery, titleQuery])
//        query.includeKey("user")
//        query.findObjectsInBackground { (objects, error) in
//            
//            if let theObjects = objects {
//                
//                self.objects = theObjects
//                self.tableView.reloadData()
//                
//            }
//        }
		
    }
    
    
        
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchTerm = searchBar.text {
            
            searchFiles(searchTerm: searchTerm)
            
        }
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       searchFiles(searchTerm: searchText)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    
    }
}
