//
//  RouteState.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/11/2.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import ReSwift

struct RouteState: StateType {
    let routes: [Route]
    let selectedIndex: Int?
}
