//
//  User.swift
//  offset
//
//  Created by Emily Kolar on 4/7/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject, NSCoding {
	
	private var _uid: String
	private var _email: String
	private var _first: String
	private var _last: String
	private var _lastPlayed: [AnyObject]
	private var _likes: [String]
	private var _photoURL: String
	private var _actions: [AnyObject]
	private var _plays: [AnyObject]
	
	init(user: [String: String]) {
		_uid = user["uid"]!
		_email = user["email"]!
		_first = user["first"]!
		_last = user["last"]!
		_photoURL = "placehold.it"
		_actions = [AnyObject]()
		_plays = [AnyObject]()
		_likes = [String]()
		_lastPlayed = [AnyObject]()
	}
	
	// MARK: NSCoding
		
	required convenience init?(coder decoder: NSCoder) {
		guard let user = decoder.decodeObject(forKey: "user") as? [String: String]
			else { return nil }
		self.init(user: user)
	}
	
	func encode(with coder: NSCoder) {
		coder.encode(self.email, forKey: "email")
	}
	
	var email: String {
		get {
			return _email;
		}
	}
	
	var uid: String {
		get {
			return _uid;
		}
	}
	
	var photoURL: String {
		get {
			return _photoURL;
		}
	}
	
	var actions: [AnyObject] {
		get {
			return _actions;
		}
	}
	
	var plays: [AnyObject] {
		get {
			return _plays;
		}
	}
	
	var likes: [String] {
		get {
			return _likes;
		}
	}
}
