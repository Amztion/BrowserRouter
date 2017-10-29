//
//  Mock.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/10/28.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Foundation

extension RouteManager {
    static let allRoutes = Browser.all.map {Route(browser: $0, wildcards: [Wildcard]())}
}
