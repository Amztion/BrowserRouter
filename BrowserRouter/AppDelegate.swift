//
//  AppDelegate.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/5/26.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        let event = NSAppleEventManager.shared()
        event.setEventHandler(self, andSelector: #selector(handleURLEvent(_:_:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }

    func handleURLEvent(_ event: NSAppleEventDescriptor, _ reply: NSAppleEventDescriptor) {
        if let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue {
            if let url = URL(string: urlString) {
                for bundle in BrowserController.allInstalledBrowsers() {
                    print("\(bundle)/n")
                }
            }
        }
    }

}

