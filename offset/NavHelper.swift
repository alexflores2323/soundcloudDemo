//
//  NavHelper.swift
//  offset
//
//  Created by Emily Kolar on 4/7/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import Foundation
import UIKit

class NavHelper {
	
	static func login() {
		appDelegate.login()
	}
	
	static private var appDelegate: AppDelegate {
		get {
			return UIApplication.shared.delegate as! AppDelegate
		}
	}
	
}
