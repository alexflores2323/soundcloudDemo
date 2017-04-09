//
//  UserHelper.swift
//  offset
//
//  Created by Emily Kolar on 4/7/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserHelper {
	
	static func saveUser(user: User) {
		UserDefaults.standard.set(user.email, forKey: "email")
		UserDefaults.standard.synchronize()
	}
	
	static func saveFIRUser(user: FIRUser) {
		UserDefaults.standard.set(user.email, forKey: "email")
		UserDefaults.standard.synchronize()
	}
	
}
