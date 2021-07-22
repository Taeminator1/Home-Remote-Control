//
//  ViewController.swift
//  ScriptLauncher
//
//  Created by Taemin Yun on 7/21/21.
//  Copyright © 2021 Taemin Yun. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var fileEditor = FileEditor(fileName: "script", fileExtension: "command", filePath: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func selectFile(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["js"]
        
        openPanel.begin { (result) -> Void in
            if result == NSApplication.ModalResponse.OK {       // Select a File
                
                if let url = openPanel.url {
                    var path: String = "\(url)"

                    // path 앞의 문자열 "file://" 삭제
                    path.removeSubrange(path.startIndex ..< path.index(path.startIndex, offsetBy: "file://".count))
                    
                    // path 뒤의 선택된 파일명 + "/" 삭제
                    while path.removeLast() != "/" { }
                    
                    self.fileEditor.filePath = path
                    let script: String = self.makeScript(commands: "cd \(path)", "node \(url.lastPathComponent)")
                    
                    if let data = script.data(using: .utf8) {
                        self.fileEditor.createFile(contents: data)
                    }
                }
            }
            else {                                              // Cancel
                
            }
        }
    }
    
    @IBAction func launchScript(_ sender: Any) {
        guard let path = fileEditor.path else {
            return
        }
        NSWorkspace.shared.openFile(path, withApplication: "Terminal")
        print("File opened: \(path)")
    }
    
    func makeScript(commands: String ...) -> String {
        return commands.reduce("") { $0 + $1 + "\n" }
    }
}

