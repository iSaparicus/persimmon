//
//  SingupViewController.swift
//  PersimmonStoryBoard
//
//  Created by Sapar Jumabek on 10/12/15.
//  Copyright © 2015 Sapar Jumabek. All rights reserved.
//

import UIKit

class SingupViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var signupButton: UIButton!
    
    var defaultPlaceholder = [String]()
    var defaultId = [String]()
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(true)
//        if PFUser.currentUser() != nil {
//            self.performSegueWithIdentifier("mainSegue", sender: nil)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.leftView = UIView(frame: CGRectMake(0, 0, 15, 50))
        emailTextField.leftViewMode = UITextFieldViewMode.Always
        usernameTextField.leftView = UIView(frame: CGRectMake(0, 0, 15, 50))
        usernameTextField.leftViewMode = UITextFieldViewMode.Always
        passwordTextField.leftView = UIView(frame: CGRectMake(0, 0, 15, 50))
        passwordTextField.leftViewMode = UITextFieldViewMode.Always
        signupButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signupButtonTouch(sender: UIButton) {
        let user = PFUser()
        user["user_name"] = self.usernameTextField.text
        user.email = self.emailTextField.text
        user.password = self.passwordTextField.text
        user.username = self.emailTextField.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print("error %@", errorString)
            } else {
                self.downloadDefaults()
            }
        }
    }
    
    func downloadDefaults(){
        let query = PFQuery(className:"GoalCategory")
        query.addAscendingOrder("priority")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as [PFObject]! {
                    for object in objects {
                        self.defaultPlaceholder.append(object["placeholderEveningExample"] as! (String))
                        self.defaultId.append(object.objectId!)
                    }
                    self.createGoals()
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func createGoals(){
        for (var i=0; i < defaultId.count; i++) {
            let goal = PFObject(className:"Goal")
            goal["user"] = PFUser.currentUser()
            goal["status"] = "InProcess"
            goal["title"] = defaultPlaceholder[i]
            goal["category"] = PFObject(withoutDataWithClassName:"GoalCategory", objectId: defaultId[i]);
            goal["priority"] = i+1;
            goal.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print(i+1)
                } else {
                    print("net")
                }
            }
        }
        self.performSegueWithIdentifier("mainSegue", sender: nil)
    }
}

