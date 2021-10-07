//
//  ContentView.swift
//  HomeRemoteControl
//
//  Created by 윤태민 on 3/24/21.
//

//  Initial view for inital excution of the Application:
//  - Network Status
//  - Controls
//  - Test

import SwiftUI

struct ContentView: View {
    @State var isConnected: Bool = false
    @State var buttonStates: [Bool] = [false, false]
    
    @State var refresh = Refresh(isStarted: false, isReleased: false)
    
    @State var record: String = UserDefaults.standard.string(forKey: "record") ?? ""
    
    let buttonNames: [String] = ["Close the window", "Turn on the airconditioner"]
    
    var body: some View {
        NavigationView {
            List {
                networkStatus
                controls
                test
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("HRC")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            fetchData(url: HRCApp.url)
        }
    }

    // fetch data from sever
    func fetchData(url: String) -> Void {
        var index: Int = 0
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                isConnected = false
                return
            }
            
            isConnected = true
            if let htmlFromURL = String(data: data, encoding: .utf8) {      // Get String starting with "\'label" in HTML from server
                for i in 0 ... htmlFromURL.count {
                    if htmlFromURL[i ..< (i + 6)] == "\'label" {
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

// MARK:- Test Section
extension ContentView {
    var networkStatus: some View {
        Section(header: Text("Network").padding(.horizontal)) {
            HStack {
                Text("Status")
                Spacer()
                isConnected == true ? Text("Connected") : Text("Failed")
            }
        }
    }
}

// MARK:- Controls
extension ContentView {
    var controls: some View {
        Section(header: Text("Controls").padding(.horizontal)) {
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
}

// MARK:- Network status
extension ContentView {
    var test: some View {
        Section(header: Text("Test").padding(.horizontal)) {
            Text("\(UserDefaults.standard.integer(forKey: "attemptsNumber"))")
                .onAppear() {
                    let tmp: Int = UserDefaults.standard.integer(forKey: "attemptsNumber")
                    UserDefaults.standard.set(tmp + 1, forKey: "attemptsNumber")
                }
            HStack {
                TextEditor(text: $record)
                    .frame(height: 100)
                Button(action: {
                    UserDefaults.standard.set(record, forKey: "record")
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Return")
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
