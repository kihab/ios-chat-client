//
//  UIViewExtensions.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/19/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addBorder(borderWidth: CGFloat, borderColor: UIColor, cornerRaduis: CGFloat) {
        self.layer.cornerRadius = cornerRaduis
        self.layer.borderColor = borderColor.CGColor
        self.layer.borderWidth = borderWidth
    }
    
}