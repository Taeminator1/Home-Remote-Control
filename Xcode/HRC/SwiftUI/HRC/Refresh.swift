//
//  Refresh.swift
//  HRC
//
//  Created by 윤태민 on 7/18/21.
//

//  Struct to refresh view by scrolling down:
//  - After scrolling at specific condition, run action.

import SwiftUI

struct Refresh {
    let minMargin: CGFloat = 80.0               // Minimal margin to refresh.
    var startOffset: CGFloat = 0                // Initial offset in the View
    var offset: CGFloat = 0                     // Offset from the initial state.
    var isStarted: Bool
    var isReleased: Bool
    
    mutating func excute(reader: GeometryProxy, action: () -> Void) {
        if startOffset == 0 {
            startOffset = reader.frame(in: .global).minY
        }
        
        offset = reader.frame(in: .global).minY
        
        // Checking if offset is more then minMargine.
        if offset - startOffset > minMargin && !isStarted {
            isStarted = true
            print("Pulled")
        }
        
        // Checking if refresh is started and drag is released.
        if startOffset == offset && isStarted && !isReleased {
            withAnimation(Animation.linear) {
                isReleased = true
            }
            isReleased = false
            isStarted = false
            print("Refreshed")
            action()
        }
    }
}
