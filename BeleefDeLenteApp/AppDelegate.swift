//
//  AppDelegate.swift
//  BeleefDeLenteApp
//
//  Created by Jeroen Wesbeek on 3/17/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Cocoa
import CleanroomLogger

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    lazy var screenSaverView = BeleefDeLenteView(frame: NSZeroRect, isPreview: false)

    @IBOutlet weak var window: NSWindow!

    override init() {
        super.init()
        
        // configure logging
        let xcodeFormat = XcodeLogFormatter()
        let aslFormat = ReadableLogFormatter()
        
        // create a configuration for logging to the Xcode console, but
        // disable ASL logging so we can use a different formatter for it
        let xcodeConfig = XcodeLogConfiguration(minimumSeverity: .Debug, logToASL: false, formatter: xcodeFormat)
        
        // create a configuration containing an ASL log recorder
        // using the aslFormat formatter. turn off stderr echoing
        // so we don’t see duplicate messages in the Xcode console
        let aslRecorder = ASLLogRecorder(formatter: aslFormat, echoToStdErr: false)
        let aslConfig = BasicLogConfiguration(minimumSeverity: .Error, recorders: [aslRecorder])
        
        // enable logging using the 2 different LogRecorders
        // that each use their own distinct LogFormatter
        Log.enable(configuration: [xcodeConfig, aslConfig])
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        guard let screenSaverView = screenSaverView, contentView = window.contentView else {
            return
        }
        
        screenSaverView.frame = contentView.bounds
        contentView.addSubview(screenSaverView)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}
