//
//  ViewController.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/17/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import UIKit
import SocketRocket

class WelcomeViewController: UIViewController, SRWebSocketDelegate {

    var socket:SRWebSocket!
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        print("SRWebSocket: webSocketDidOpen")
        socket.send("Hello There!!!");
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        
        print("SRWebSocket: didFailWithError:\(error)")
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        
        print("SRWebSocket: didReceiveMessage")
        print(message)
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        
        print("SRWebSocket: didCloseWithCode: \(code)")
        print("SRWebSocket: didCloseWithReason:\(reason)")
        print("SRWebSocket: didCloseWasClear:\(wasClean)")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        socket = SRWebSocket(URLRequest: NSURLRequest(URL: NSURL(string: "\(Constants.webSocketURL)?\(Constants.userNameParam)=karim")!))
        socket.delegate = self
        socket.open()
        
    }


}

