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
    
    static var buttonStates: [Bool] = [false, false]
    @State var isConnected: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView(isConnected: $isConnected)
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
                isConnected = false
                return
            }
            
            isConnected = true
            if let htmlFromURL = String(data: data, encoding: .utf8) {
                for i in 0 ... htmlFromURL.count {
                    if htmlFromURL[i ..< (i + 6)] == "\"label" {
                        
                        HRCApp.buttonStates[index] = htmlFromURL[(i + 10) ..< (i + 15)] == "true " ? true : false
                    
                        index += 1
                        if index == 2 { break }
                    }
                }
            }
        }
        task.resume()
    }
}
