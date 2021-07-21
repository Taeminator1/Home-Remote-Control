//
//  FileEditor.swift
//  ScriptLauncher
//
//  Created by Taemin Yun on 7/21/21.
//  Copyright © 2021 Taemin Yun. All rights reserved.
//

import Foundation

struct FileEditor {
    var fileName: String
    var fileExtension: String
    var path: String
    
    func readFile() -> String? {
        let userURL = try! FileManager.default.url(for: .userDirectory, in: .localDomainMask, appropriateFor: nil, create: false)
        let folderURL = userURL.appendingPathComponent(path)
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: folderURL).appendingPathExtension(fileExtension)
        
        var res: String?
        do {
            let data = try Data(contentsOf: fileURL)
            if let str = String(data: data, encoding: .utf8) {
                res = str
            }
        } catch {
            print("Unaable to read \"\(fileName)\" file in Users/\(path).")
        }
        
        return res
    }
    
    func writeFile(contents: String, isOverwritable: Bool = false) {
        let userURL = try! FileManager.default.url(for: .userDirectory, in: .localDomainMask, appropriateFor: nil, create: false)
        let folderURL = userURL.appendingPathComponent(path)
        
        if FileManager.default.fileExists(atPath: folderURL.path) {
            let fileURL = URL(fileURLWithPath: fileName, relativeTo: folderURL).appendingPathExtension(fileExtension)
            
            if isOverwritable || !FileManager.default.fileExists(atPath: fileURL.path) {
                guard let data = contents.data(using: .utf8) else {
                    print("Unable to convert contents.")
                    return
                }
                
                do {
                    try data.write(to: fileURL)
                    print("File saved: \(fileURL.absoluteURL)")
                } catch {
                    print(error.localizedDescription)
                }
            }
            else {
                print("Enable to overwrite \"\(fileName)\", Check the overwrite parameter of this method.")
            }
        }
        else {
            print("Unable to access Users/\(path).")
        }
    }
}
