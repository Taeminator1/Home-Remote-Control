//
//  ToggleView.swift
//  HomeRemoteControl
//
//  Created by 윤태민 on 3/24/21.
//
import SwiftUI
import WebKit

struct ToggleView: View {
    
    @Binding var isChecked: Bool
    var index: Int = 0
    
    var toggleName: String
    
    var body: some View {
        
        Toggle(isOn: $isChecked) {
            Text(toggleName)
                .onChange(of: isChecked) { _ in
                    print("Button\(index + 1) is changed")
                    javaScriptFunction(index: index)
                }
        }
    }
    
    func javaScriptFunction(index: Int) -> Void {
        HRCApp.wkWebView.evaluateJavaScript("buttonClicked('btn\(index + 1)');", completionHandler: { (result, error) in
            if let anError = error {
                print("evaluateJavaScript infoUpdate Error \(anError.localizedDescription)")
            }
        })
    }
}

struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleView(isChecked: .constant(false), toggleName: "Test")
    }
}
