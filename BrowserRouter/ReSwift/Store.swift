//
//  Store.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/11/3.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import ReSwift

let mainStore = Store<RouteState>(
    reducer: RouteReducer,
    state: nil,
    middleware: [RouteManagerMiddleware]
)
