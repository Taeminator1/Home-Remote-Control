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
    
    var fileDirectory: String? {    // 파일 디렉터리
        get {
            UserDefaults.standard.string(forKey: "path")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "path")
        }
    }
    
    var path: String? {             // 전체 경로
        guard let fileDirectory = self.fileDirectory else {
            return nil
        }
        
        return "\(fileDirectory)/\(fileName).\(fileExtension)"
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
