//
//  SentMessageTableViewCell.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/18/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation
import UIKit

class SentMessageTableViewCell : UITableViewCell {

    
    @IBOutlet weak var sentMessageLabel: UILabel!
    @IBOutlet weak var sentMessageDateLabel: UILabel!
    @IBOutlet weak var sentMessageView: UIView!
    @IBOutlet weak var calloutHeightConstraint: NSLayoutConstraint!
    
}