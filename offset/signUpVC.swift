//
//  signUpVC.swift
//  offset
//
//  Created by Logan Caracci on 3/18/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import Firebase

class signUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var repeatPassword: UITextField!
    
    @IBOutlet weak var fullnameTxt: UITextField!
       
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var webTxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
	
	@IBOutlet weak var firstNameInput: UIScrollView!
	@IBOutlet weak var lastNameInput: UIScrollView!
	
    
    var scrollViewHeight : CGFloat = 0
    
    
    var keyboard = CGRect()
	
	var storage: FIRStorageReference!
	
	var db: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		storage = FIRStorage.storage().reference()
		db = FIRDatabase.database().reference()
		
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        NotificationCenter.default.addObserver(self, selector: #selector(signUpVC.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(signUpVC.hideKeybard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // declare hide kyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        
        
        
        // declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        
        
        
        // alignment
        avaImg.frame = CGRect(x: self.view.frame.size.width / 2 - 40, y: 40, width: 80, height: 80)
        usernameTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y + 90, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        repeatPassword.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        emailTxt.frame = CGRect(x: 10, y: repeatPassword.frame.origin.y + 60, width: self.view.frame.size.width - 20, height: 30)
        fullnameTxt.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        bioTxt.frame = CGRect(x: 10, y: fullnameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        webTxt.frame = CGRect(x: 10, y: bioTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        
        signUpBtn.frame = CGRect(x: 20, y: webTxt.frame.origin.y + 50, width: self.view.frame.size.width / 4, height: 30)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
        
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: signUpBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20

        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)

    }

    
    // call picker to select image
    func loadImg(_ recognizer:UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    // connect selected image to our ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // hide keyboard if tapped
    func hideKeyboardTap(_ recoginizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // show keyboard
    func showKeyboard(_ notification:Notification) {
        
        // define keyboard size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        // move up UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        })
    }
    
    
    // hide keyboard func
    func hideKeybard(_ notification:Notification) {
        
        // move down UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        })
    }
	
    
    @IBAction func signUpBtn_click(_ sender: Any) {
        
        print("sign up hit")
        self.view.endEditing(true)
        
        // if fields are empty
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPassword.text!.isEmpty || emailTxt.text!.isEmpty) {
            
            // alert message
            let alert = UIAlertController(title: "PLEASE", message: "fill all fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            
            // VERY VERY ***** VERY VERY IMPORTANT -return
            return
        }
        
        // if different passwords
        if passwordTxt.text != repeatPassword.text {
            
            // alert message
            let alert = UIAlertController(title: "PASSWORDS", message: "do not match", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            
            // VERY VERY VERY ** VERY VERY IMPORTANT -return
            return
        }
		
		let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
		let md = FIRStorageMetadata(dictionary: ["content-type": "image/jpeg"])
		let username = self.usernameTxt.text!
		
		if let email = emailTxt.text {
			if let password = passwordTxt.text {
				FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {
					user, error in
					if user != nil {
						UserDefaults.standard.set(user?.uid, forKey: "username")
						UserDefaults.standard.synchronize()
						self.storage.child((user?.uid)!).child("avatar.jpg").put(avaData!, metadata: md, completion: { data, error in
							let url = String(describing: data!.downloadURL()!)
							self.db.child("users").child((user?.uid)!).setValue([
								"avatar": url,
								"username": username,
								"email": email,
								"firstName": "first",
								"lastName": "last"
							])
						})
					}
					else {
						let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
							let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
							alert.addAction(ok)
							self.present(alert, animated: true, completion: nil)
					}
				})
			}
		}
    }
    
    @IBAction func cancelBtn_click(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
   
    
    
}
