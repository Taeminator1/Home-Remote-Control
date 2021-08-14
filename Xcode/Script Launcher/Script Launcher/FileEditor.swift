//
//  FileEditor.swift
//  ScriptLauncher
//
//  Created by Taemin Yun on 7/21/21.
//  Copyright © 2021 Taemin Yun. All rights reserved.
//

//  Edit File with FileManager.

import Foundation

struct FileEditor {
    
    var fileName: String
    var fileExtension: String       // txt, js, ...
    
    var fileDirectory: String? {
        get {
            UserDefaults.standard.string(forKey: "path")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "path")
        }
    }
    
    var path: String? {
        guard let fileDirectory = self.fileDirectory else {
            return nil
        }
        
        // /Users/userName/.../fileName.fileExtension
        return "\(fileDirectory)/\(fileName).\(fileExtension)"
    }
    
    func createFile(contents: Data?) {
        // chmod 744 [fileName]         // Set the attributes in Terminal.
        // -rwxr--r--                   // Result
        let attributes: [FileAttributeKey: Any]? = [FileAttributeKey.posixPermissions: 0o744]
        guard let path = self.path else {
            return
        }
        FileManager.default.createFile(atPath: path, contents: contents, attributes: attributes)
        print("File saved: \(path)")
    }
}
