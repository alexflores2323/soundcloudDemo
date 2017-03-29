//
//  NowPlayingViewController.swift
//  AudioCloud
//
//  Created by Alex Flores on 3/17/17.
//  Copyright  © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class NowPlayingViewController: UIViewController {
    
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageview: UIImageView!
    @IBOutlet var tapCover: UITapGestureRecognizer!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    
    
    var object: PFObject?
    var player: AVPlayer?
    
    var isPlaying = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let theObject = object {
            if let coverLink = (theObject.object(forKey: "cover") as? PFFile)?.url {
                if let coverURL = URL(string: coverLink) {
                    coverImageview.sd_setImage(with: coverURL)
                }
            }
            if let user = theObject.object(forKey: "user") as? PFUser {
                user.fetchIfNeededInBackground(block: { (userObject, error) in
                    if let theUser = userObject as? PFUser {
                        self.usernameButton.setTitle(theUser.username, for: .normal)
                    }
                })
            }
            titleLabel.text = theObject.object(forKey: "title") as? String
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let currentUser = PFUser.current(), let audioObject = object {
            
            let query = PFQuery(className: "Activity")
            query.whereKey("user", equalTo: currentUser)
            query.whereKey("audio", equalTo: audioObject)
            query.whereKey("type", equalTo: "play")
            query.findObjectsInBackground(block: { (objects, error) in
                if let theError = error {
                    print("???????? \(theError)")
                }
                else if let theObjects = objects {
                    if theObjects.count == 0 {
                        let activityObject = PFObject(className: "Activity")
                        activityObject.setObject(currentUser, forKey: "user")
                        activityObject.setObject(audioObject, forKey: "audio")
                        activityObject.setObject("play", forKey: "type")
                        activityObject.setObject(Date(), forKey: "lastPlayed")
                        activityObject.saveEventually()
                    }
                    else {
                        let activityObject = theObjects.first
                        activityObject?.setObject(Date(), forKey: "lastPlayed")
                        activityObject?.saveEventually()
                    }
                }
            })
        }
        playAudio()
        
    }

        @IBAction func dismissButtonPressed(_ sender: UIButton) {
            dismiss(animated: true) {
                
                // call login function from AppDelegate.swift class
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()

            }
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
        let activity = PFObject(className: "Activity")
        if let currentUser = PFUser.current() {
            activity.setObject(currentUser, forKey: "user")
        }
        activity.setObject("save", forKey: "type")
        if let theObject = object {
            activity.setObject(theObject, forKey: "audio")
        }
        activity.saveInBackground()
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        if let songLink = (object?.object(forKey: "audioFile") as? PFFile)?.url {
            let shareText = "Check out my new song: \(songLink)"
            let activityController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)

        }
    }
    
    
    func playAudio() {
        guard let audioURLString = (object?.object(forKey: "audioFile") as? PFFile)?.url else {
            print("no audio url found")
            return
        }
        guard let thisString = audioURLString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            print("encodeing error")
            return
        }
        guard let audioURL = URL(string: thisString) else {
            print("cannot create url")
            return
        }
        let playerItem = AVPlayerItem(url: audioURL)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        isPlaying = true
    }

    
}













