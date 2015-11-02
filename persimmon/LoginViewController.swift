//
//  LoginViewController.swift
//  PersimmonStoryBoard
//
//  Created by Sapar Jumabek on 10/12/15.
//  Copyright © 2015 Sapar Jumabek. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var signinButton: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("segueSignin", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookButton.layer.cornerRadius = 5
        signinButton.layer.cornerRadius = 5
        signupButton.layer.cornerRadius = 5
        signupButton.layer.borderColor = UIColor.whiteColor().CGColor
        signupButton.layer.borderWidth = 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}