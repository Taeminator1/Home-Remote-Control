//
//  AppDelegate.swift
//  ScriptLauncher
//
//  Created by Taemin Yun on 7/21/21.
//  Copyright © 2021 Taemin Yun. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var launchScript: NSMenuItem!
    @IBOutlet weak var openAtLogin: NSMenuItem!
    
    let statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    // for Opening at Login
    let helperBundleName = "com.Taeminator.ScriptLauncher-Launch"
    var foundHelper: Bool = true
    
    var fileEditor = FileEditor(fileName: "script", fileExtension: "command")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let icon = NSImage(named: "MenubarIcon")
        icon?.isTemplate = true
        statusBar.button?.image = icon
        statusBar.menu = menu
        
        launchScript.isEnabled = fileEditor.fileDirectory == nil ? false : true
        
        // 현재 실행중인 파일 중 helperBundleName이 있다면 true 반환
        foundHelper = NSWorkspace.shared.runningApplications.contains { $0.bundleIdentifier == helperBundleName }
        openAtLogin.state = foundHelper ? .on : .off
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func selectFileClicked(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["js"]
        
        openPanel.begin { [self] (result) -> Void in
            if result == NSApplication.ModalResponse.OK {       // Select a File
                
                if let url = openPanel.url {
                    var path: String = "\(url)"

                    // path 앞의 문자열 "file://" 삭제
                    path.removeSubrange(path.startIndex ..< path.index(path.startIndex, offsetBy: "file://".count))
                    
                    // path 뒤의 선택된 파일명 + "/" 삭제
                    while path.removeLast() != "/" { }
                    
                    fileEditor.fileDirectory = path
                    launchScript.isEnabled = true
                    let script: String = self.makeScript(commands: "cd \(path)", "node \(url.lastPathComponent)")
                    if let data = script.data(using: .utf8) {
                        fileEditor.createFile(contents: data)
                    }
                }
                else {
                    fileEditor.fileDirectory = nil
                    launchScript.isEnabled = false
                }
            }
            else {                                              // Cancel
                fileEditor.fileDirectory = nil
                launchScript.isEnabled = false
            }
        }
    }
    
    @IBAction func launchScriptClicked(_ sender: Any) {
        guard let path = fileEditor.path else {
            return
        }
        
        if NSWorkspace.shared.openFile(path, withApplication: "Terminal") {
            print("File open succeed: \(path)")
        }
        else {
            print("File open failed: \(path)")
            fileEditor.fileDirectory = nil
            launchScript.isEnabled = false
        }
    }
    
    @IBAction func openAtLoginClicked(_ sender: Any) {
        openAtLogin.state = openAtLogin.state == .on ? .off : .on
        SMLoginItemSetEnabled(helperBundleName as CFString, openAtLogin.state == .on)
    }
    
    @IBAction func quitClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    
    func makeScript(commands: String ...) -> String {
        return commands.reduce("") { $0 + $1 + "\n" }
    }
}
