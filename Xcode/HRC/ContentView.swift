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
                                refresh.refresh()
                            }
                            
                            // checking if invalid becomes valid ...
                            if refresh.startOffset == refresh.offset && refresh.started && refresh.released && refresh.invalid {
                                refresh.invalid = false
                                print("C")
                                refresh.refresh()
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
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isConnected: .constant(true))
    }
}
