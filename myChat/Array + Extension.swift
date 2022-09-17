//
//  Array + Extension.swift
//  myChat
//
//  Created by Никита Макаревич on 17.09.2022.
//

import UIKit

extension Array where Element: Equatable {
        
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
        }
}
