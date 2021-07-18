//
//  ContentView.swift
//  HomeRemoteControl
//
//  Created by 윤태민 on 3/24/21.
//

import SwiftUI

struct ContentView: View {
    @Binding var isConnected: Bool
    @State var refresh = Refresh(started: false, released: false)
    
    var buttonNames: [String] = ["Close the window", "Turn on the airconditioner"]
    
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
                    ForEach(0 ..< 2) { index in
                        ToggleView(isChecked: HRCApp.buttonStates[index], index: index, toggleName: buttonNames[index])
                            .disabled(!isConnected)
                    }
                }
                .background(GeometryReader { reader -> Color in
                        DispatchQueue.main.async {
                            if refresh.startOffset == 0 {
                                refresh.startOffset = reader.frame(in: .global).minY
                            }
                            
                            refresh.offset = reader.frame(in: .global).minY
                            
                            if refresh.offset - refresh.startOffset > 80 && !refresh.started {
                                refresh.started = true
                                print("A")
                            }
                            
                            // checking if refresh is started and drag is released ...
                            if refresh.startOffset == refresh.offset && refresh.started && !refresh.released {
                                withAnimation(Animation.linear) {
                                    refresh.released = true
                                }
                                print("B")
                                abc()
                            }
                            
                            // checking if invalid becomes valid ...
                            if refresh.startOffset == refresh.offset && refresh.started && refresh.released && refresh.invalid {
                                refresh.invalid = false
                                print("C")
                                abc()
                            }
                        }
                        return Color.clear
                })
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("HRC")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func abc() {
        if refresh.startOffset ==  refresh.offset {
            print("Refreshed")
            def()
            
            refresh.released = false
            refresh.started = false
        }
        else {
            refresh.invalid = true
        }
    }
    
    func def() {
        fetchData(url: HRCApp.url)
        print("Connection: \(isConnected)")
        print("button1: \(HRCApp.buttonStates[0])")
        print("button2: \(HRCApp.buttonStates[1])")
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isConnected: .constant(true))
    }
}
