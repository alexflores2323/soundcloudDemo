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
import CoreGraphics
import ImageIO

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
	
        cell.captionLabel.text = (object["description"] as! String)
		cell.musicLengthLabel.text = (object["length"] as! String).uppercased()
		let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        if let postedDate = object["createdAt"] as? String {
            cell.timeLabel.text = postedDate
        }
		let coverURL = URL(string: object["cover"] as! String)

		
		URLSession.shared.dataTask(with: coverURL!) { (data, response, error) in
			if error != nil {
				print("Failed fetching image: \(String(describing: error?.localizedDescription))")
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
		//		URLSession.shared.dataTask(with: URL(string: coverURL)!) { (data, response, error) in
//			if error != nil {
//				print("Failed fetching image: \(error?.localizedDescription)")
//				return
//			}
//			guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//				print("Not a proper HTTPURLResponse or statusCode")
//				return
//			}
//			
//			DispatchQueue.main.async {
//				let cgImage = UIImage(data: data!)!.cgImage!
//				
//				let width = cgImage.width / 2
//				let height = cgImage.height / 2
//				let bitsPerComponent = cgImage.bitsPerComponent
//				let bytesPerRow = cgImage.bytesPerRow
//				let colorSpace = cgImage.colorSpace
//				let bitmapInfo = cgImage.bitmapInfo
//				
//				let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)
//				
//				context!.interpolationQuality = CGInterpolationQuality.high
//				context?.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: CGFloat(width), height: CGFloat(height))))
//				
//				//deprecated:
//				//CGContextDrawImage(context, CGRect(origin: CGPointZero, size: CGSize(width: CGFloat(width), height: CGFloat(height))), cgImage)
//				
//				let scaledImage = context?.makeImage()
//			}
//		}.resume()
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
		// keep a websocket open, and reload the table every time new data shows up
		db.child("activity").observe(.value, with: { (snapshot) in
			if let data = snapshot.value! as? [String: AnyObject] {
				self.audioKeys.removeAll()
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
