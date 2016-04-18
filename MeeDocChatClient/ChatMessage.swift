//
//  ChatMessage.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/18/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation


enum MessageType:String {
    
    case sentMessage = "sent"
    case recievedMessage = "recieved"
}

struct ChatMessage {
    
    var message:String!
    var sender:String!
    var type:MessageType!
    var date:NSDate!

    init(message:String, sender:String, type:MessageType, date:NSDate){
        self.message = message
        self.sender = sender
        self.type = type
        self.date = date
    }

    init(dictionary: NSDictionary, type:MessageType, date:NSDate){
        self.message = dictionary[Constants.message] as? String
        self.sender = dictionary[Constants.sender] as? String
        self.type = type
        self.date = date
    }
    
    
    
}