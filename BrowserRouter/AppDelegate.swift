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
        launchRouteManageWindowController()
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(handleURLEvent(_:_:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
        NSApplication.shared.setActivationPolicy(.accessory)
        RouteManager.shared.add(chromeRoute)
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        launchRouteManageWindowController()
        return true
    }
}

extension AppDelegate {
    @objc func handleURLEvent(_ event: NSAppleEventDescriptor, _ reply: NSAppleEventDescriptor) {
        guard let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue else {
            print("url string is nil")
            return
        }
        
        (RouteManager.shared.matched(with: urlString)?.browser ?? Browser.default).open(urlString)
    }
    
    fileprivate func launchRouteManageWindowController() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        
        let mainWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "RouteManageWindowController")) as! NSWindowController
        
        mainWindowController.showWindow(self)
    }
}

