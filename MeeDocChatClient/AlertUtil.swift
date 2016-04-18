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
        
        let alert = UIAlertController(title: "Oops!", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        view.presentViewController(alert, animated: true, completion: nil)
    
    }
}