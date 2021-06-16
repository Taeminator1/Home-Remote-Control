//
//  ContentView.swift
//  HomeRemoteControl
//
//  Created by 윤태민 on 3/24/21.
//

import SwiftUI


struct ContentView: View {
    
    var buttonNames: [String] = ["Close the window", "Turn on the airconditioner"]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("State")) {
                    HStack {
                        Text("Connection")
                        Spacer()
                        HRCApp.isConnected == true ? Text("OK") : Text("Fail")
                    }
                }
                Section(header: Text("Control")) {
                    ForEach(0 ..< 2) { index in
                        ToggleView(isChecked: HRCApp.buttonStates[index], index: index, toggleName: buttonNames[index])
                            .disabled(!HRCApp.isConnected)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("HRC")
//            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
