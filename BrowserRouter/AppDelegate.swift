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
    func applicationDidFinishLaunching(_ notification: Notification) {
        let chrome = Browser.all.filter{$0.identifier == Browser.Identifier.chrome}.first!
        let wildcards = [Wildcard(url: "google.com")]
        
        let chromeRoute = Route(browser: chrome, wildcards: wildcards as! [Wildcard])
        RouteManager.shared().add(chromeRoute)
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(handleURLEvent(_:_:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        return true
    }
}

extension AppDelegate {
    func handleURLEvent(_ event: NSAppleEventDescriptor, _ reply: NSAppleEventDescriptor) {
        if let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue {
            (RouteManager.shared().matched(with: urlString)?.browser ?? Browser.default).open(urlString)
        }
    }
}

