//
//  Mock.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/10/28.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Foundation

extension Pattern {
    static let sakWilcards = [Pattern(url: "*sankuai.com*"), Pattern(url: "*tapd.cn*"), Pattern(url: "*dper.com*"), Pattern(url: "*dianpingoa.com*"), Pattern(url: "*neixin.cn*"), Pattern(url: "*sankuai.info*"), Pattern(url: "*dper.com*")]
}

let chromeRoute = Route(browser: Browser.chrome!, wildcards: Pattern.sakWilcards as! [Pattern])
