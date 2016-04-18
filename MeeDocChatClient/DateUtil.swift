//
//  DateUtil.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/18/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation

class DateUtil {
    
    struct DateFormats {
        static let IsoDate = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let FriendlyDate = "dd MMM. hh:mm a"
        static let DateOnly = "EE, dd MMM"
        static let DateOnlyWithYear = "dd MMM YYYY"
        static let TimeOnly = "hh:mm a"
    }
    
    class func getStringFromDate(date:NSDate, format:String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }
}