//
//  ViewController.swift
//  ScriptLauncher
//
//  Created by Taemin Yun on 7/21/21.
//  Copyright © 2021 Taemin Yun. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var fileEditor = FileEditor(fileName: "script", fileExtension: "command", path: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        print(Bundle.main.resourcePath!)
//        print(Bundle.main.bundlePath)
//        print(Bundle.main.executablePath!)
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

                    // path 앞의 문자열 "file:///Users" 삭제
                    let range = path.startIndex ..< path.index(path.startIndex, offsetBy: 13)
                    path.removeSubrange(range)

                    // path 뒤의 마지막 경로 삭제
                    while path.removeLast() != "/" { }
                    print(path)
                    
//                    var path: String = Bundle.main.resourcePath!
//                    // path 앞의 문자열 "/Users" 삭제
//                    let range = path.startIndex ..< path.index(path.startIndex, offsetBy: 6)
//                    path.removeSubrange(range)
                    
                    
                    self.fileEditor.path = path
                    let contents: String = """
                    cd \(self.fileEditor.path)
                    node \(url.lastPathComponent)
                    """
                    self.fileEditor.writeFile(contents: contents, isOverwritable: true)
                }
            }
            else {                                              // Cancel
                
            }
        }
    }
    
    @IBAction func launchScript(_ sender: Any) {
        NSWorkspace.shared.openFile("/Users\(self.fileEditor.path)/script.command", withApplication: "Terminal")
    }
    
    @discardableResult
    func shell(_ args: String...) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
}

