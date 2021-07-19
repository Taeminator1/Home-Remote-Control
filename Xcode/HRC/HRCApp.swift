//
//  HRCApp.swift
//  HRC
//
//  Created by 윤태민 on 6/3/21.
//

import SwiftUI
import WebKit

@main
struct HRCApp: App {
    static let url: String = PersonalInfo.strURL
    
    static let wkWebView = WKWebView()
    static let request: URLRequest = URLRequest.init(url: NSURL.init(string: HRCApp.url)! as URL)
    
    init() {
        HRCApp.wkWebView.load(HRCApp.request)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
