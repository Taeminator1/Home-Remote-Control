//
//  HRCApp.swift
//  HRC
//
//  Created by 윤태민 on 6/3/21.
//

//  Initilze for the Application:
//  - Request the server
//  Before run, you should set the variables url for String in HRCApp struct.

import SwiftUI
import WebKit

@main
struct HRCApp: App {
    static let url: String = PersonalInfo.strURL        // "http://..."

    static let wkWebView = WKWebView()
    static let request: URLRequest = URLRequest.init(url: NSURL.init(string: HRCApp.url)! as URL)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear() {
                    HRCApp.wkWebView.load(HRCApp.request)
                    sleep(2)        // 앱 시작시에 Toggle 조작에 대해 A JavaScript exception occurred 유도하기 위해 지연 발생시킴
                }
        }
    }
}
