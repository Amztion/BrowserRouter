//
//  RouteManageSplitViewController.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/10/26.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

class RouteManageSplitViewController: NSSplitViewController {
    
    var listViewController: RouteListViewController? {
        return self.splitViewItems.first?.viewController as? RouteListViewController
    }
    
    var contentViewController: RouteContentViewController? {
        return self.splitViewItems.last?.viewController as? RouteContentViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configSplitView()
        
        mainStore.dispatch(RouteListLoadingAction())
    }
    
    fileprivate func configSplitView() {
        splitView.setPosition(splitView.frame.size.width * 1.0/3.0, ofDividerAt: 0)
    }
}
