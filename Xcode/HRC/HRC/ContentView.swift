//
//  ContentView.swift
//  HomeRemoteControl
//
//  Created by 윤태민 on 3/24/21.
//

import SwiftUI

struct ContentView: View {
    @State var isConnected: Bool = false
    @State var buttonStates: [Bool] = [false, false]
    
    @State var refresh = Refresh(started: false, released: false)
    
    let buttonNames: [String] = ["Close the window", "Turn on the airconditioner"]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("State")) {
                    HStack {
                        Text("Connection")
                        Spacer()
                        isConnected == true ? Text("OK") : Text("Fail")
                    }
                }
                Section(header: Text("Control")) {
                    ForEach(0 ..< buttonStates.count) {
                        ToggleView(isChecked: $buttonStates[$0], index: $0, toggleName: buttonNames[$0])
                            .disabled(!isConnected)
                    }
                }
                .background(GeometryReader { reader -> Color in
                    DispatchQueue.main.async {
                        refresh.excute(reader: reader) {
                            fetchData(url: HRCApp.url)
                        }
                    }
                    return Color.clear
                })
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("HRC")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            fetchData(url: HRCApp.url)
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
                        
                        buttonStates[index]  = htmlFromURL[(i + 10) ..< (i + 15)] == "true " ? true : false
                    
                        index += 1
                        if index == buttonStates.count { break }
                    }
                }
            }
        }
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
