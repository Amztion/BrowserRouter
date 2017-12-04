//
//  RouteListActions.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/11/2.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import ReSwift

struct RouteListLoadAction: Action {
    var routes: [Route]
}

struct RouteListRemoveAction: Action {
    var route: Route
    var index: Int
}

struct RouteListAddAction: Action {
    var route: Route
}

struct RouteListModifyAction: Action {
    var route: Route
    var index: Int
}

struct RouteListSelectAction: Action {
    var route: Route
    var index: Int
}
