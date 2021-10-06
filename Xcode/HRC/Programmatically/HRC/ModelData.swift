//
//  ModelData.swift
//  HRC
//
//  Created by 윤태민 on 10/5/21.
//

import Foundation
import UIKit

struct Section: Codable {
    var title: String
    var contents: [String]
}

struct ModelData {
    static let stringData = """
        [
            {
                "title": "Network",
                "contents": [
                    "Status"
                ]
            },
            {
                "title": "Controls",
                "contents": [
                    "Close the window",
                    "Turn on the airconditioner"
                ]
            }
        ]
    """
    
    static func getSectionData() -> [Section] {
        var sections: [Section] = []
        
        if let jsonData = stringData.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                sections = try decoder.decode([Section].self, from: jsonData)
            }
            catch {
            }
        }
        
        return sections
    }
}
