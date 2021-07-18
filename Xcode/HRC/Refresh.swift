//
//  Refresh.swift
//  HRC
//
//  Created by 윤태민 on 7/18/21.
//

import SwiftUI

struct Refresh {
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    var started: Bool
    var released: Bool
    var invalid: Bool = false
    
    mutating func refresh() {
        if startOffset ==  offset {
            print("Refreshed")
            released = false
            started = false
        }
        else {
            invalid = true
        }
    }
}
