//
//  ToggleView.swift
//  HomeRemoteControl
//
//  Created by 윤태민 on 3/24/21.
//

import SwiftUI
import WebKit

struct ToggleView: View {
    
    @State var isChecked: Bool = true
    @State var index: Int = 0
    
    var toggleName: String = ""
    
    var body: some View {
        
        Toggle(isOn: self.$isChecked) {
            Text(toggleName)
            
            if self.isChecked {
                Text("\(self.toggleAction(state: "On", index: index))")
            } else {
                Text("\(self.toggleAction(state: "Off", index: index))")
            }
        }
    }
}

// MARK: - Functions
extension ToggleView {
    func toggleAction(state: String, index: Int) -> String {
        
        // 버튼을 연속적으로 빠르게 누를 때, 먹히는 경우가 생김
        print("button\(index + 1) is \(state)")
        javaScriptFunction(index: index)
        
        return ""
    }
    
    func javaScriptFunction(index: Int) -> Void {

        // 초기 버튼 상태가져올 때 눌림
        // 웹페이지 로딩 중에 일어나기 때문에 에러로 처리 됨
        // completionHandler의 인자로 result는 언제 사용되지??
        HRCApp.wkWebView.evaluateJavaScript("btn\(index + 1)ButtonClicked();", completionHandler: { (result, error) in
            if let anError = error {
                print("evaluateJavaScript infoUpdate Error \(anError.localizedDescription)")
            }
        })
    }
}

struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleView()
    }
}
