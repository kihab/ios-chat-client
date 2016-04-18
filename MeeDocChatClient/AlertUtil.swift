//
//  AlertUtil.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/18/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation
import UIKit

class AlertUtil {
    
    
    class func showErrorAlert(view:UIViewController, msg:String){
        
        let alert = UIAlertController(title: "Oops!", message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        view.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    
    class func showOkCancelAlert(view:UIViewController, title: String, message: String, okHandler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)? ){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            if let okHandler = okHandler {
                okHandler(action)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            if let cancelHandler = cancelHandler {
                cancelHandler(action)
            }
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        
        view.presentViewController(alertController, animated: true) {}
    }
}