//
//  ViewController.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/17/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import UIKit
import SocketRocket

class ViewController: UIViewController, SRWebSocketDelegate {

    var socket:SRWebSocket!
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        print("webSocketDidOpen")
        socket.send("Hello There!!!");
        //        socket.close()
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        print("didFailWithError:\(error)")
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        print("didReceiveMessage")
        print(message)
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("didCloseWithCode")
        print("Code:\(code)")
        print("Reason:\(reason)")
        print("wasClear:\(wasClean)")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket = SRWebSocket(URLRequest: NSURLRequest(URL: NSURL(string: "https://codingtest.meedoc.com/ws?username=karim")!))
        socket.delegate = self
        socket.open()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

