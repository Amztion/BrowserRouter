//
//  RouteContentAction.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/11/2.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import ReSwift

protocol RouteContentAction: Action {
    var route: Route {get}
}
