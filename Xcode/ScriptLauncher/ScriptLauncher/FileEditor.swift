//
//  FileEditor.swift
//  ScriptLauncher
//
//  Created by Taemin Yun on 7/21/21.
//  Copyright © 2021 Taemin Yun. All rights reserved.
//

import Foundation

struct FileEditor {
    var fileName: String            // 파일 이름
    var fileExtension: String       // 파일 확장자
    var filePath: String?           // 파일 경로
    
    var path: String? {
        guard let filePath = self.filePath else {
            return nil
        }
        return "\(filePath)/\(fileName).\(fileExtension)"
    }
    
    func createFile(contents: Data?) {
        // chmod 744 [fileName]
        // -rwxr--r--
        let attributes: [FileAttributeKey: Any]? = [FileAttributeKey.posixPermissions: 0o744]
        
        guard let path = self.path else {
            return
        }
        FileManager.default.createFile(atPath: path, contents: contents, attributes: attributes)
        print("File saved: \(path)")
    }
}
