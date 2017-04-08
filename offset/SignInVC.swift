//
//  SignInVC.swift
//  offset
//
//  Created by Logan Caracci on 3/18/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
	var db: FIRDatabaseReference!
	
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
        
    @IBOutlet weak var forgotBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		db = FIRDatabase.database().reference()
		
		// listen for user login and logout activity, and do stuff based on that
		setAuthListener()
		
        label.frame = CGRect(x: 10, y: 80, width: self.view.frame.size.width - 20, height: 50)
        usernameTxt.frame = CGRect(x: 10, y: label.frame.origin.y + 70, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        forgotBtn.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 30, width: self.view.frame.size.width - 20, height: 30)
        
        signInBtn.frame = CGRect(x: 20, y: forgotBtn.frame.origin.y + 40, width: self.view.frame.size.width / 4, height: 30)
        signInBtn.layer.cornerRadius = signInBtn.frame.size.width / 20
        
        signUpBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: signInBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(SignInVC.hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        

    }
    
    // hide keyboard func
    func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

	func setAuthListener() {
		FIRAuth.auth()?.addStateDidChangeListener({ auth, user in
			if user != nil {
				let uid = user!.uid
				let userData = ["uid": uid, "first": "", "last": "", "email": ""]
				let u = User(user: userData)
				UserHelper.saveUser(user: u)
				let appDelegate = UIApplication.shared.delegate as! AppDelegate
				appDelegate.login()
			}
			else {
				print("signed out")
			}
		})
	}
	
	@IBAction func signInBtn_click(_ sender: Any) {
        
        print("sign in hit")
        
        // hide keyboard
        self.view.endEditing(true)
        
        // if textfields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            // show alert message
            let alert = UIAlertController(title: "Please", message: "fill in fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
			return
        }
		
		if let email = usernameTxt.text {
			if let pass = passwordTxt.text {
				FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: nil)
			}
		}
    }
    
    
   
}
