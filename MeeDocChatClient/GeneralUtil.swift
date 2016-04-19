//
//  GeneralUtil.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/19/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation
import UIKit

class GeneralUtil {
    
    static func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    static func heightForView(text:String, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = UIFont(name: "Thonburi", size: 15.0)
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }

}