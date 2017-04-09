////
////  Activity.swift
////  offset
////
////  Created by Emily Kolar on 4/8/17.
////  Copyright © 2017 Logan Caracci. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//enum ActivityType: String {
//	case Like = "like", Play = "play"
//}
//
//struct Activity {
//	var user: String
//	var audio: String
//	var lastPlayed: String
//	fileprivate var _type: String
//	var activityType: ActivityType
//	var type: String {
//		get {
//			return _type
//		}
//		set(t) {
//			activityType = ActivityType.init(rawValue: t)!
//			_type = t
//		}
//	}
//	
//	var dictionary: [String: String] {
//		return [
//			"user" : self.user,
//			"audio": self.audio,
//			"lastPlayed": self.lastPlayed,
//			"type": self.activityType.rawValue
//		]
//	}
//	
//	init(type: String, user: String, audioObject: Audio) {
//		self.user = user
//		self.type = type
//		self.audio = audioObject.autogenKey as String
//		self.lastPlayed = audioObject.object["lastPlayed"] as! String
//	}
//	
//	init?(snapshot: FIRDataSnapshot) {
//		guard let dict = snapshot.value as? [String: String] else { return nil }
//		guard let user = dict["user"] else { return nil }
//		guard let audio  = dict["audio"]  else { return nil }
//		guard let type = dict["type"] else { return nil }
//		
//		self.audio = audio
//		self.user = user
//		self.type = type
//	}
//}
