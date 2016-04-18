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

