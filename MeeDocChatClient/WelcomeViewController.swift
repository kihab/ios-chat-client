//
//  ViewController.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/17/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!    
    @IBOutlet weak var WelcomLabelTopConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(animated: Bool) {
        //
        self.userNameTextField.text = ""
        
        //..
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //..
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);


    }
    
    func keyboardWillShow(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.WelcomLabelTopConstraint.constant = self.WelcomLabelTopConstraint.constant - 70
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.WelcomLabelTopConstraint.constant = Constants.initialWelcomLabelTopConstraint
        })
    }        
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if identifier ==  Constants.openChatSegue {
            guard let text = userNameTextField.text where !text.isEmpty else {
                AlertUtil.showErrorAlert(self, msg: "Please enter you name.")
                return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier ==  Constants.openChatSegue {
            let viewController = segue.destinationViewController as! ChatViewController
            viewController.userName = self.userNameTextField.text
        }
    }
}

