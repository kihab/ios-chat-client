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

class ChatViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, SRWebSocketDelegate {

    @IBOutlet weak var typeMessageBottomConstraint: NSLayoutConstraint!
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

    //Holds the DataSource of the tableViewController
    var chatMessages:[ChatMessage]!
    
    //UserName
    var userName:String!
    
    //Socket
    var socket:SRWebSocket!
    
    //Adjusting
    var numberOfLinesSoFar: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Observers on the keyboard to adjust screen layout on show/hide
        addKeyboardObservers()

        //Setup some ViewController UI
        setupUI()

        //Init TableView Datasource
        chatMessages = [ChatMessage]()

        //Preparing Send/Recieve Messages Audio
        AudioUtil.prepareAudio()

        //Start Socket Connection
        startChat()

    }
    
    //Observers on the keyboard to adjust screen layout on show/hide
    func addKeyboardObservers() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //Adjust Screen layout when Keyboard appears
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.typeMessageBottomConstraint.constant = keyboardFrame.size.height
        })
    }
    
    //Adjust Screen layout when Keyboard disappear
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.typeMessageBottomConstraint.constant = 0
        })
    }
    
    //Some UI preparations
    private func setupUI() {
        
        sendMessageButton.enabled = false
        sendMessageSpinner.hidden = true
        writeMessageTextView.text = Constants.typeMessagePlaceHolder
        writeMessageTextView.textColor = UIColor.lightGrayColor()
        writeMessageTextView.addBorder(0.2, borderColor: UIColor.grayColor(), cornerRaduis: 4)
        
        //Dismiss Keyboard when user taps any where is the screen
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Start Socket Connection
    private func startChat() {
        
        socket = SocketService.getChatSocket(self.userName)
        socket.delegate = self
        socket.open()
    }
    
    //Restart Socket
    private func restartChat() {

        socket.delegate = nil
        socket = nil
        
        startChat()
        
    }
    
    //Send message Button
    @IBAction func sendMessage(sender: AnyObject) {
        
        //If the user didn't type a message show an alert and dont send empty message
        if (self.writeMessageTextView.text == Constants.typeMessagePlaceHolder ||
            self.writeMessageTextView.text.isEmpty) {
            
            AlertUtil.showErrorAlert(self, msg: "Please type a message first")
            return
        }
        
        //Build message
        let msg = self.writeMessageTextView.text
        self.writeMessageTextView.text = ""
        let chatMessage = ChatMessage(message: msg, sender: userName, type: MessageType.sentMessage, date: NSDate())
        
        //Append to Table DataSource and Reload
        self.chatMessages.append(chatMessage)
        self.chatTableView.reloadData()
        
        //send UTF8 encoded string or data to server
        socket.send(msg)
        
        //Play sent message Sound
        AudioUtil.sentMessageAudio.play()

        //Scroll to bottom so that the user always see the latest messages
        self.scrollToBottom()
    }

    //Alert the user that he has beed disconnected when leaving the chat screen
    override func willMoveToParentViewController(parent: UIViewController?) {
        if (parent == nil) {
            AlertUtil.showErrorAlert(self, msg: "Disconneted From Server");
        }
    }
    
    //Closing Socket when leaving the chat Screen
    override func viewWillDisappear(animated: Bool) {

        if (socket != nil) {
            socket.close()
            socket.delegate = nil
            socket = nil
        }

    }
    
    //To show latest messages
    func scrollToBottom() {
        // Handle Scrolling
        GeneralUtil.delay(0.001) { () -> Void in
            let numberOfSections = self.chatTableView.numberOfSections
            if numberOfSections > 0 {
                let numberOfRows = self.chatTableView.numberOfRowsInSection(numberOfSections-1)
                if numberOfRows > 0 {
                    let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                    self.chatTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: false)
                }
            }
        }
    }
        
    //========================= TextView Delegates =========================
    
    //TetxView placeHolder
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
    
    //Adjusting TextView Height
    func textViewDidChange(textView: UITextView) {
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
    
    
    //Showing cells based on message Type
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
    
    //Adjust table cell height based on message
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let message: ChatMessage = self.chatMessages[indexPath.row]
        var height: CGFloat = Constants.initialMessageCellHeight + GeneralUtil.heightForView(message.message, width: chatTableView.frame.width - Constants.messageSidesSpacing)
        
        if message.type == MessageType.recievedMessage {
            height += Constants.messageSenderNameHeight
        }
        
        return height
    }
    
    //Header above
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat(0.1)
    }
    
    //Rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.chatMessages.count
    }
    
    //Sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //========================= Socket Delegates =========================
    
    //On Socket Open
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        print("SRWebSocket: webSocketDidOpen")
        
        self.sendMessageButton.enabled = true
    }
    
    
    //On message reveived
    //Message will either be an NSString if the server is using text or NSData if the server is using binary
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        
        print("SRWebSocket: didReceiveMessage: \(message)")
        
        var chatMessage:ChatMessage!
        if let message = message as? String {
            
            let messageDict = message.convertStringToDictionary()
            chatMessage = ChatMessage(dictionary: messageDict!, type: MessageType.recievedMessage, date: NSDate())
            self.chatMessages.append(chatMessage)
            self.chatTableView.reloadData()
            self.scrollToBottom()
            AudioUtil.receivedMessageAudio.play()
            
        }else{
            
            print("Error Parsing Response Message :( ")
        }
    }
    
    //On Fail
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        print("SRWebSocket: didFailWithError:\(error)")
        
        //Disable send button
        self.sendMessageButton.enabled = false

        //Alert user to reconnect
        AlertUtil.showOkCancelAlert(self, title: "Oops!", message: "Server Disconnected :( ", okTitle: "Reconnect", okHandler: { (action) in
            self.restartChat()
            }, cancelHandler: nil)
        

    }
    
    //On Close
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("SRWebSocket: didCloseWithCode: \(code)")
        print("SRWebSocket: didCloseWithReason:\(reason)")
        print("SRWebSocket: didCloseWasClear:\(wasClean)")

        //Disable send button
        self.sendMessageButton.enabled = false
        
        //Alert user to reconnect
        AlertUtil.showOkCancelAlert(self, title: "Oops!", message: "Server Disconnected :( ", okTitle: "Reconnect", okHandler: { (action) in
            self.restartChat()
            }, cancelHandler: nil)
        

    }
    
    //Removing the Keyboard Observers
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
}