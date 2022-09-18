//
//  TableViewExtension.swift
//  myChat
//
//  Created by Никита Макаревич on 18.09.2022.
//

import UIKit

public extension UIView {
    
    /// - parameter duration: custom animation duration
    func fadeIn(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
}

