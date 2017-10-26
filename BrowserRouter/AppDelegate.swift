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
        let safari = BrowserManager.shared().all.filter{$0.identifier == "com.apple.Safari"}.first!
        BrowserManager.shared().default = safari
        
        let chrome = BrowserManager.shared().all.filter{$0.identifier == "com.google.Chrome"}.first!
        let wildcards = [Wildcard(url: "*google.com*")]
        let chromeRoute = Route(browser: chrome, wildcards: wildcards as! [Wildcard])
        RouteManager.shared().add(chromeRoute)
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        let event = NSAppleEventManager.shared()
        event.setEventHandler(self, andSelector: #selector(handleURLEvent(_:_:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }

    func handleURLEvent(_ event: NSAppleEventDescriptor, _ reply: NSAppleEventDescriptor) {
        if let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue {
            let browser = (RouteManager.shared().matched(with: urlString)?.browser ?? BrowserManager.shared().default)!
            
            browser.open(urlString)
        }
    }

}

