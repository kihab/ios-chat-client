//
//  ReceivedMessageTableViewCell.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/18/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation
import UIKit

class ReceivedMessageTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var receivedMessageLabel: UILabel!
    @IBOutlet weak var receivedView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var senderNameLabel: UILabel!
}