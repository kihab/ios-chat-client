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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  Constants.openChatSegue {
            let viewController = segue.destinationViewController as! ChatViewController
            
            //TODO::show alert if username is empty
            viewController.userName = self.userNameTextField.text
        }
    }

}

