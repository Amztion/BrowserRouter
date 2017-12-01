//
//  RouteContentViewController.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/10/30.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import ReSwift

class RouteContentViewController: NSViewController {

    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var browserSelectPopUpButton: NSPopUpButton!
    
    private var currentRoute: Route?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainStore.subscribe(self)
        
        configPopUpButton()
        configSegmentedControl()
    }
    
    private func configPopUpButton() {
        browserSelectPopUpButton.removeAllItems()
        browserSelectPopUpButton.addItems(withTitles: Browser.all.map {$0.identifier})
        Browser.all.forEach { (browser) in
            if let item = browserSelectPopUpButton.item(withTitle: browser.identifier) {
                item.title = browser.name
                item.image = browser.icon
            }
        }
    }
    
    private func configSegmentedControl() {
        updateSegementedControl()
    }
    
    @IBAction func browserSelectionDidChanged(_ sender: NSPopUpButton) {
        print("brower: \(sender.indexOfSelectedItem)")
    }
    
    @IBAction func contentTextFieldDidChanged(_ sender: NSTextField) {
        let selected = tableView.selectedRow
        print("row = \(selected), text = \(sender.stringValue)")
    }
    
    @IBAction func segmentedControlClicked(_ sender: NSSegmentedControl) {
        print("segmentedController selected = \(sender.indexOfSelectedItem)")
        
    }
}

extension RouteContentViewController {
    fileprivate func updateSegementedControl() {
        segmentedControl.setEnabled(tableView.selectedRow == -1 ? false : true, forSegment: 1)
    }
}

extension RouteContentViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = RouteState
    
    func newState(state: RouteState) {
//        
//        defer {
//            tableView.reloadData()
//        }
//        
//        guard state.routes.count > state.selectedIndex else {
//            currentRoute = nil
//            return
//        }
//        
//        let selectedRoute = state.routes[state.selectedIndex]
//        
//        currentRoute = selectedRoute
    }
}

extension RouteContentViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return currentRoute?.wildcards.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return nil
        
    }
}

extension RouteContentViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateSegementedControl()
    }
}
