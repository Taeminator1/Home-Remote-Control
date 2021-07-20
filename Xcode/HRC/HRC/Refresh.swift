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
    
    mutating func excute(reader: GeometryProxy, action: () -> Void) {
        
        if startOffset == 0 {
            startOffset = reader.frame(in: .global).minY
        }
        
        offset = reader.frame(in: .global).minY
        
        if offset - startOffset > 80 && !started {
            started = true
            print("Pulled")
        }
        
        // checking if refresh is started and drag is released ...
        if startOffset == offset && started && !released {
            withAnimation(Animation.linear) {
                released = true
            }
            released = false
            started = false
            action()
            print("Refreshed")
        }
    }
}
