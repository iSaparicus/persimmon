//
//  SigninViewController.swift
//  PersimmonStoryBoard
//
//  Created by Sapar Jumabek on 10/12/15.
//  Copyright © 2015 Sapar Jumabek. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var singinButton: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if PFUser.currentUser() != nil {
            //self.performSegueWithIdentifier("mainSegue", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singinButton.layer.cornerRadius = 5
        usernameTextField.leftView = UIView(frame: CGRectMake(0, 0, 15, 50))
        usernameTextField.leftViewMode = UITextFieldViewMode.Always
        passwordTextField.leftView = UIView(frame: CGRectMake(0, 0, 15, 50))
        passwordTextField.leftViewMode = UITextFieldViewMode.Always
    }

    @IBAction func signinButtonTouch(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("mainSegue", sender: nil)
            } else {
                print("error")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
