//
//  ModelData.swift
//  HRC
//
//  Created by 윤태민 on 10/5/21.
//

//  For data that is used in cell of TableView:
//  - Format: Json.
//  - Data
//      - section: Title of section.
//      - contents: Various controls in a specific section.

import Foundation
import UIKit

struct Section: Codable {
    var section: String
    var contents: [String]
}

struct ModelData {
    static let stringData = """
        [
            {
                "section": "Network",
                "contents": [
                    "Status"
                ]
            },
            {
                "section": "Controls",
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
