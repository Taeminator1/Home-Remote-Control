//
//  AppDelegate.swift
//  ScriptLauncher
//
//  Created by Taemin Yun on 7/21/21.
//  Copyright © 2021 Taemin Yun. All rights reserved.
//

//  Initialize for the Application:
//  - Status item for menu
//  - Open at Login

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var launchScript: LaunchScript!
    @IBOutlet weak var openAtLogin: NSMenuItem!
    
    let statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    // For Opening at Login
    let helperBundleName = "com.Taeminator.Script-Launcher-Launch"
    var foundHelper: Bool = true
    
    var fileEditor = FileEditor(fileName: "script", fileExtension: "command")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // MARK:- Set status item for menu.
        if let button = statusBar.button, let icon = NSImage(named: "MenubarIcon") {
            icon.isTemplate = true
            button.image = icon
        }
        statusBar.menu = menu
        
        // MARK:- If file has been loaded in App, excute the file.
        launchScript.isEnabled = fileEditor.fileDirectory == nil ? false : true
        launchScriptClicked("")
        
        // MARK:- Set Open at Login.
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
            if result == NSApplication.ModalResponse.OK, let url = openPanel.url {       // Select a File.
                var path: String = "\(url)"

                // "file:///Users/userName/.../someDir/fileName.js"
                // → "/Users/userName/.../someDir/fileName.js"
                path.removeSubrange(path.startIndex ..< path.index(path.startIndex, offsetBy: "file://".count))
                
                // "/Users/userName/.../someDir/fileName.js"
                // → "/Users/userName/.../someDir"
                while path.removeLast() != "/" { }
                
                launchScript.update(&fileEditor, path: path)
                let script: String = self.makeScript(commands: "cd \(path)", "node \(url.lastPathComponent)")
                fileEditor.createFile(contents: script.data(using: .utf8))
            }
            else {                                              // Cancel.
                launchScript.update(&fileEditor)
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
            launchScript.update(&fileEditor)
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
