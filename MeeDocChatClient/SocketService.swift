//
//  SocketService.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/18/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation
import SocketRocket

class SocketService {

    static func getChatSocket(username:String) -> SRWebSocket{

        let encodedUsername = username.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlRequest = NSURLRequest(URL: NSURL(string: "\(Constants.webSocketURL)?\(Constants.userNameParam)=\(encodedUsername)")!)
        let socket = SRWebSocket(URLRequest: urlRequest)
        
        return socket
    }
}