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
    static let url: String = ""
    
    static let wkWebView = WKWebView()
    static let request: URLRequest = URLRequest.init(url: NSURL.init(string: HRCApp.url)! as URL)
    
    static var buttonStates: [Bool] = [false, false]
    static var isConnected: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear() {
                    fetchData(url: HRCApp.url)
                    HRCApp.wkWebView.load(HRCApp.request)
                    
                    sleep(1)        // loading 시간 고려해 지연 발생시킴
                }
        }
    }
    
    func fetchData(url: String) -> Void {
        
        var index: Int = 0
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            
            guard let data = data else {
                print(String(describing: error))
                HRCApp.isConnected = false
                return
            }
            
            if let htmlFromURL = String(data: data, encoding: .utf8) {
                for i in 0 ... htmlFromURL.count {
                    // HTML문에서 "label 찾기
                    if htmlFromURL[htmlFromURL.index(htmlFromURL.startIndex, offsetBy: i)] == "\"" &&
                        htmlFromURL[htmlFromURL.index(htmlFromURL.startIndex, offsetBy: i + 1)] == "l" &&
                        htmlFromURL[htmlFromURL.index(htmlFromURL.startIndex, offsetBy: i + 2)] == "a" &&
                        htmlFromURL[htmlFromURL.index(htmlFromURL.startIndex, offsetBy: i + 3)] == "b" &&
                        htmlFromURL[htmlFromURL.index(htmlFromURL.startIndex, offsetBy: i + 4)] == "e" &&
                        htmlFromURL[htmlFromURL.index(htmlFromURL.startIndex, offsetBy: i + 5)] == "l" {
                    
                        let range = htmlFromURL.index(htmlFromURL.startIndex, offsetBy: i + 10)..<htmlFromURL.index(htmlFromURL.startIndex, offsetBy: i + 15)
                    
                        if htmlFromURL[range] == "true " {
                            HRCApp.buttonStates[index] = true
                        } else {
                            HRCApp.buttonStates[index] = false
                        }
                        
                        index += 1
                        if index == 2 { break }
                    }
                }
            }
        }
        task.resume()
    }
}
