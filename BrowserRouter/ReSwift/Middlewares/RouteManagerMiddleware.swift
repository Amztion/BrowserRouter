//
//  RouteManagerMiddleware.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/11/11.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import ReSwift

let RouteManagerMiddleware: Middleware<RouteState> = { dispatch, getState in
    return { next in
        return { action in
            var handledAction: Action = action
            
            if let state = getState() {
                switch action {
                case let action as RouteListLoadingAction:
                    RouteManager.shared.load(completion: { (success, routes) in
                        dispatch(RouteListLoadedAction(routes: routes))
                    })
                case let action as RouteListLoadedAction:
                    handledAction = RouteManager.shared.handle(action)
                case let action as RouteListRemoveAction:
                    handledAction = RouteManager.shared.handle(action)
                case let action as RouteListAddAction:
                    handledAction = RouteManager.shared.handle(action)
                case let action as RouteListModifyAction:
                    handledAction = RouteManager.shared.handle(action)
                case let action as RouteListSelectAction:
                    handledAction = action
                default:
                    break
                }
            }
            
            return next(handledAction)
        }
    }
}

extension RouteManager {
    func handle(_ loadAction: RouteListLoadedAction) -> RouteListLoadedAction {
        return RouteListLoadedAction(routes: RouteManager.shared.routes)
    }
    
    func handle(_ removeAction: RouteListRemoveAction) -> RouteListRemoveAction {
        let removedRoute = removeAction.route
        
        do {
            try RouteManager.shared.remove(removedRoute)
        } catch {
            // TODO: Error handler
            print("Error")
        }
        
        return removeAction
    }
    
    func handle(_ addAction: RouteListAddAction) -> RouteListAddAction {
        let addedRoute = addAction.route
        
        RouteManager.shared.add(addedRoute)
        
        return addAction
    }
    
    func handle(_ modifyAction: RouteListModifyAction) -> RouteListModifyAction {
        let modifiedRoute = modifyAction.route
        let modifiedIndex = modifyAction.index
        
        try? RouteManager.shared.replace(modifiedRoute, at: modifiedIndex)
        
        return modifyAction
    }
}
