//
//  Route.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/10/25.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

struct Route {
    let browser: Browser
    let wildcards: [Wildcard]
    
    init(browser: Browser, wildcards: [Wildcard]) {
        self.browser = browser
        self.wildcards = wildcards
    }
    
    func match(_ url: String) -> Bool {
        return self.wildcards.filter {$0.match(url)}.count > 0
    }
    
    func identifier() -> String {
        return browser.identifier
    }
}
