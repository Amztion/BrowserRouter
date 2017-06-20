//
//  Route.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/6/3.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

class Route {
    var defaultBrowser: Browser
    var link: String
    
    var uts: Int64
    
    init?(browser: Browser, link: String) {
        self.link = link
        self.defaultBrowser = browser
        self.uts = Int64(Int(NSDate().timeIntervalSince1970))
    }
}
