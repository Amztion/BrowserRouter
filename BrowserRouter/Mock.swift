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

extension Wildcard {
    static let sakWilcards = [Wildcard(url: "*sankuai.com*"), Wildcard(url: "*tapd.cn*"), Wildcard(url: "*dper.com*"), Wildcard(url: "*dianpingoa.com*"), Wildcard(url: "*neixin.cn*"), Wildcard(url: "*sankuai.info*")]
}

let chromeRoute = Route(browser: Browser.chrome!, wildcards: Wildcard.sakWilcards as! [Wildcard])

