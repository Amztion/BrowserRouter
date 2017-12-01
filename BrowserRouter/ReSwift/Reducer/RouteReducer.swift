//
//  RouteReducer.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/11/2.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import ReSwift

let RouteReducer: Reducer<RouteState> = { action, state -> RouteState in
    switch action {
    case let action as RouteListLoadAction:
        return RouteListLoadActionReducer(action, state)
    case let action as RouteListRemoveAction:
        return RouteListRemoveActionReducer(action, state)
    case let action as RouteListAddAction:
        return RouteListAddActionReducer(action, state)
    case let action as RouteListModifyAction:
        return RouteListModifyActionReducer(action, state)
    case let action as RouteListSelectAction:
        return RouteListSelectActionReducer(action, state)
    default:
        return RouteState(routes: [Route](), selectedIndex: 0)
    }
}

fileprivate let RouteListLoadActionReducer: Reducer<RouteState> = { action, state -> RouteState in
    let loadAction = action as! RouteListLoadAction
    
    return RouteState(routes: loadAction.routes ?? [Route](), selectedIndex: nil)
}

fileprivate let RouteListRemoveActionReducer: Reducer<RouteState> = { action, state -> RouteState in
    guard var routes = state?.routes else {
        return RouteState(routes: [Route](), selectedIndex: nil)
    }
    
    let removeAction = action as! RouteListRemoveAction
    
    let removedRoute = removeAction.route
    let removedIndex = removeAction.index
    
    routes.remove(at: removedIndex)
    
    var selectedIndex: Int?
    
    if let lastSelectedIndex = state?.selectedIndex {
        if lastSelectedIndex < removedIndex {
            selectedIndex = removedIndex < routes.count - 1 ? removedIndex : routes.count - 1
        } else {
            selectedIndex = removedIndex > 0 ? lastSelectedIndex - 1 : removedIndex
        }
    }
    
    return RouteState(routes: routes, selectedIndex: selectedIndex)
}

fileprivate let RouteListAddActionReducer: Reducer<RouteState> = { action, state -> RouteState in
    let addAction = action as! RouteListAddAction
    let addedRoute = addAction.route
    
    var routes = state?.routes ?? [Route]()
    routes.append(addedRoute)
    
    return RouteState(routes: routes, selectedIndex: routes.count - 1)
}

fileprivate let RouteListModifyActionReducer: Reducer<RouteState> = { action, state in
    let modifiedAction = action as! RouteListModifyAction
    let modifiedRoute = modifiedAction.route
    let modifiedIndex = modifiedAction.index
    

    return RouteState(routes: state?.routes ?? [Route](), selectedIndex: modifiedIndex)
}

fileprivate let RouteListSelectActionReducer: Reducer<RouteState> = { action, state in
    let selectAction = action as! RouteListSelectAction
    let selectedIndex = selectAction.index
    
    return RouteState(routes: state?.routes ?? [Route](), selectedIndex: selectedIndex)
}
