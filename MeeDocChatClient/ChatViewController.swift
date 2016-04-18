//
//  ChatViewController.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/18/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SocketRocket

class ChatViewController : UIViewController, SRWebSocketDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIScrollViewDelegate {

    //
    @IBOutlet weak var typeMessageView: UIView!
    @IBOutlet weak var sendMessageSpinner: UIActivityIndicatorView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var typeMessageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var writeMessageTextView: UITextView!  {
        didSet {
            writeMessageTextView.delegate = self
        }
    }

    //
    var chatMessages:[ChatMessage]!
    var userName:String!
    var socket:SRWebSocket!
    
    //
    var numberOfLinesSoFar: CGFloat = 1
    
    //Audio
    var receivedMessageAudio = AVAudioPlayer()
    var sentMessageAudio = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        chatMessages = [ChatMessage]()
        
        //...
        startChat()

        //..
        setupUI()
        
        //..
        prepareAudio()

    }
    
    private func setupUI() {
        sendMessageButton.enabled = false
        sendMessageSpinner.hidden = true
        writeMessageTextView.text = Constants.typeMessagePlaceHolder
        writeMessageTextView.textColor = UIColor.lightGrayColor()
        addBorder(writeMessageTextView, borderWidth: 0.2, borderColor: UIColor.grayColor(), cornerRaduis: 4)
    }
    
    func addBorder(view: UIView, borderWidth: CGFloat, borderColor: UIColor, cornerRaduis: CGFloat) {
        view.layer.cornerRadius = cornerRaduis
        view.layer.borderColor = borderColor.CGColor
        view.layer.borderWidth = borderWidth
    }
    
    func setConstraintValue(constraint: NSLayoutConstraint, constantValue: CGFloat) {
        constraint.constant = constantValue
    }
    
    private func startChat() {
        
        socket = SocketService.getChatSocket(self.userName)
        socket.delegate = self
        socket.open()
    }
    
    private func restartChat() {

        //TODO:: Alert user that the connection is down and we are restarting it
            //restating ...
        
        socket.delegate = nil
        socket = nil
        
        startChat()
        
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        
        //TODO::check if the socket is not opened yet
        
        //TODO:: check if the socket is down
        
        //TODO:: don't send if the textField is empty
        
        //
        let msg = self.writeMessageTextView.text
        self.writeMessageTextView.text = ""
        //
        let chatMessage = ChatMessage(message: msg, sender: userName, type: MessageType.sentMessage, date: NSDate())
        self.chatMessages.append(chatMessage)
        self.chatTableView.reloadData()
        
        //
        socket.send(msg)
        
        //
        self.sentMessageAudio.play()
        
        //
//        self.toggleSendingMessageIndicator(false)

    }
    
 
//    func toggleSendingMessageIndicator(showIndicator: Bool) {
//        
//        sendMessageButton.hidden = showIndicator
//        sendMessageSpinner.hidden = !showIndicator
//        if showIndicator {
//            sendMessageSpinner.startAnimating()
//        }else {
//            sendMessageSpinner.stopAnimating()
//        }
//        
//    }

    override func viewWillDisappear(animated: Bool) {
        
        if (socket != nil) {
            socket.close()
            socket.delegate = nil
            socket = nil
        }

    }
    
    //========================= TextView Delegates =========================
    
    //...
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.typeMessagePlaceHolder
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
//        var emptyMessage = (textView.text == "")
//        
//        if !emptyMessage {
//            self.toggleSendButton(true, imageName: "send_ico_pressed")
//        } else {
//            resetSendingMessageState()
//        }
        
        let maxNumberOfLines: CGFloat = 4
        let numLines = (textView.contentSize.height/textView.font!.lineHeight) - 1
        if (numLines <= maxNumberOfLines) {
            if numLines > numberOfLinesSoFar {
                typeMessageViewHeight.constant += textView.font!.lineHeight
                numberOfLinesSoFar = numLines
            }
        }
    }
    
    //========================= TableView Delegates =========================
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message: ChatMessage = self.chatMessages[indexPath.row]
        
        if message.type == MessageType.sentMessage {
            let  cell = chatTableView.dequeueReusableCellWithIdentifier("sentMessage") as! SentMessageTableViewCell
            cell.sentMessageView.layer.cornerRadius = 10
            cell.sentMessageLabel.text = message.message
            cell.sentMessageDateLabel.text = DateUtil.getStringFromDate(message.date, format: DateUtil.DateFormats.FriendlyDate)
            return cell
        }else{
            let  cell = chatTableView.dequeueReusableCellWithIdentifier("receivedMessage") as! ReceivedMessageTableViewCell
            cell.receivedView.layer.cornerRadius = 10
            cell.receivedMessageLabel.text = message.message
            cell.senderNameLabel.text = message.sender
            cell.dateLabel.text = DateUtil.getStringFromDate(message.date, format: DateUtil.DateFormats.FriendlyDate)
            return cell

        }
        
        
    }
    
    func heightForView(text:String, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = UIFont(name: "Thonburi", size: 15.0)
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let message: ChatMessage = self.chatMessages[indexPath.row]
        var height: CGFloat = Constants.initialMessageCellHeight + heightForView(message.message, width: chatTableView.frame.width - Constants.messageSidesSpacing)
        
        if message.type == MessageType.recievedMessage {
            height += Constants.messageSenderNameHeight
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat(0.1)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.chatMessages.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    
    //========================= Socket Delegates =========================
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        print("SRWebSocket: webSocketDidOpen")
        
        self.sendMessageButton.enabled = true
    }

    //Message will either be an NSString if the server is using text or NSData if the server is using binary
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        
        print("SRWebSocket: didReceiveMessage: \(message)")
        
        var chatMessage:ChatMessage!
        if let message = message as? String {
            
            let messageDict = message.convertStringToDictionary()
            chatMessage = ChatMessage(dictionary: messageDict!, type: MessageType.recievedMessage, date: NSDate())
            self.chatMessages.append(chatMessage)
            self.chatTableView.reloadData()
            
        }else{
            
            print("Error Parsing Response Message :( ")
        }
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
    
    
    
    //========================= Audio =========================
    
    private func prepareAudio() {
        prepareAudioForPlay(&sentMessageAudio, audioName: "sentMessageAudio")
        prepareAudioForPlay(&receivedMessageAudio, audioName: "receivedMessageAudio")
    }
    
    
    func prepareAudioForPlay(inout audio: AVAudioPlayer, audioName: String) {
        
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(audioName, ofType: "mp3")!)
        
        do {
            // Removed deprecated use of AVAudioSessionDelegate protocol
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            let _:NSError?
            
            audio = try AVAudioPlayer(contentsOfURL: alertSound)
            audio.prepareToPlay()
        } catch _ {
        }
    }
    
}