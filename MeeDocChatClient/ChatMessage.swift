//
//  ChatMessage.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/18/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation

struct ChatMessage {
    
    var message:String!
    var sender:String!

    init(message:String, sender:String){
        self.message = message
        self.sender = sender
    }

    init(dictionary: NSDictionary){
        message = dictionary[Constants.message] as? String
        sender = dictionary[Constants.sender] as? String
    }
    
    
    
}