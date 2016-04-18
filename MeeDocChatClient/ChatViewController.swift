//
//  ChatViewController.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/18/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation
import UIKit
import SocketRocket

class ChatViewController : UIViewController, SRWebSocketDelegate {
    
    var userName:String!
    var socket:SRWebSocket!
    
    @IBOutlet weak var recievedMessage: UILabel!
    @IBOutlet weak var sentMessage: UILabel!
//    TODO:: change this to textfield
    @IBOutlet weak var writeMessageTextView: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //...
        startChat()
        
        // ..
        self.sendMessageButton.enabled = false
    }
    
    private func startChat() {
        
        socket = SocketService.getChatSocket(self.userName)
        socket.delegate = self
        socket.open()
    }
    
    private func restartChat() {

        //TODO:: Alert user that the connection is down and we are restarting it
            //restating ...
        
        socket.delegate = nil;
        socket = nil;
        
        startChat()
        
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        
        //TODO::check if the socket is not opened yet
        
        //TODO:: check if the socket is down
        
        //TODO:: don't send if the textField is empty
        
        socket.send(self.writeMessageTextView.text)
        
        self.sentMessage.text = self.writeMessageTextView.text
        self.writeMessageTextView.text = ""
        
    }
    
 
    //....

    override func viewWillDisappear(animated: Bool) {
        
        //TODO:: Handle closing the socket
        
//        if let socket = socket {
//            print("Closing socket ...")
//            socket.close()
//        }

    }
    
    
    
    //========================= Socket Delegates =========================
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        print("SRWebSocket: webSocketDidOpen")
        
        self.sendMessageButton.enabled = true;
    }

    //Message will either be an NSString if the server is using text or NSData if the server is using binary
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        
        print("SRWebSocket: didReceiveMessage: \(message)")
        
        var chatMessage:ChatMessage!
        if let message = message as? String {
            
            let messageDict = message.convertStringToDictionary()
            chatMessage = ChatMessage(dictionary: messageDict!)
            
        }else{
            
            print("Error Parsing Response Message :( ")
        }
        
        self.recievedMessage.text = chatMessage.message        
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        
        print("SRWebSocket: didFailWithError:\(error)")
        
        self.sendMessageButton.enabled = false
//        restartChat()

    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        
        self.sendMessageButton.enabled = false
        
        print("SRWebSocket: didCloseWithCode: \(code)")
        print("SRWebSocket: didCloseWithReason:\(reason)")
        print("SRWebSocket: didCloseWasClear:\(wasClean)")

//        restartChat()

    }    
}