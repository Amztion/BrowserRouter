//
//  Route.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/10/25.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

struct Route {
    let identifier: UUID
    let browser: Browser
    let wildcards: [Pattern]
    
    static let emptyList = [Route]()
    
    init(browser: Browser, wildcards: [Pattern]) {
        identifier = UUID()
        self.browser = browser
        self.wildcards = wildcards
    }
    
    func match(_ url: String) -> Bool {
        return self.wildcards.filter {$0.match(url)}.count > 0
    }
}

extension Route: Equatable {
    static func ==(lhs: Route, rhs: Route) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
