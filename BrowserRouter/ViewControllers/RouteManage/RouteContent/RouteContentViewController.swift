//
//  RouteContentViewController.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/10/30.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import ReSwift

class RouteContentViewController: NSViewController {
    private enum SegmentedControlIndex: Int {
        case add
        case remove
    }

    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var browserSelectPopUpButton: NSPopUpButton!
    
    private var currentRoute: Route?
    private var selectedIndex: Int! = NonselectedIndex
    
    private var addingIndex: Int?
    private var addingUrl = ""
    
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
        if let selectedItem = sender.selectedItem {
            if let index = sender.itemArray.index(of: selectedItem) {
                if Browser.all.count > index {
                    let selectedBrowser = Browser.all[index]
                    
                    let route = Route(browser: selectedBrowser, wildcards: currentRoute?.wildcards ?? EmptyWildcard)
                    currentRoute = route
                    
                    mainStore.dispatch(RouteListModifyAction(route: route, index: selectedIndex))
                } else {
                    // TODO: Error Message
                    print("Error message")
                }
            }
        }
    }
    
    @IBAction func contentTextFieldDidChanged(_ sender: NSTextField) {
        let selected = tableView.selectedRow
        print("row = \(selected), text = \(sender.stringValue)")
    }
    
    @IBAction func segmentedControlClicked(_ sender: NSSegmentedControl) {
        if let selectedIndex = SegmentedControlIndex(rawValue: sender.selectedSegment) {
            switch selectedIndex {
            case .add:
                add()
            case .remove:
                remove()
            }
        }
    }
}

extension RouteContentViewController {
    fileprivate func updateSegementedControl() {
        segmentedControl.setEnabled(!(tableView.selectedRow == -1), forSegment: SegmentedControlIndex.remove.rawValue)
        segmentedControl.setEnabled(addingIndex == nil, forSegment: SegmentedControlIndex.add.rawValue)
    }
    
    func add() {
        guard let currentRoute = currentRoute else {
            return
        }
        
        guard addingIndex == nil else {
            return
        }
        
        addingIndex = currentRoute.wildcards.count
        tableView.insertRows(at: IndexSet(integer: addingIndex!), withAnimation: .effectGap)
    }
    
    func remove() {
        guard let currentRoute = currentRoute else {
            return
        }
        
        if tableView.selectedRow != NonselectedIndex {
            var wildcards = currentRoute.wildcards
            wildcards.remove(at: tableView.selectedRow)
            
            mainStore.dispatch(RouteListModifyAction(
                route: Route(browser: currentRoute.browser, wildcards: wildcards),
                index: tableView.selectedRow
            ))
        }
    }
}

extension RouteContentViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = RouteState
    
    func newState(state: RouteState) {
        defer {
            tableView.reloadData()
        }
        
        guard state.selectedIndex != NonselectedIndex else {
            view.isHidden = true
            currentRoute = nil
            return
        }
        
        guard state.routes.count > state.selectedIndex else {
            currentRoute = nil
            return
        }
        
        view.isHidden = false
        let selectedRoute = state.routes[state.selectedIndex]
        selectedIndex = state.selectedIndex
        currentRoute = selectedRoute
        
        browserSelectPopUpButton.select(
            browserSelectPopUpButton.item(
                at: Browser.all.index{return $0.identifier == selectedRoute.browser.identifier} ?? 0
            )
        )
    }
}

extension RouteContentViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let currentRoute = currentRoute else {
            return 0
        }
        
        return currentRoute.wildcards.count + (addingIndex == nil ? 0 : 1)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let currentRoute = currentRoute else {
            return nil
        }
        
        let view = tableView.makeView(
            withIdentifier: NSUserInterfaceItemIdentifier(
                rawValue: RouteContentListTableCellView.CellViewIdentifier.RouteList
            ),
            owner: self
            ) as? RouteContentListTableCellView
        
        view?.set(item: RouteContentListItem(
            content: row < currentRoute.wildcards.count ? currentRoute.wildcards[row].url : "test"
        ))
        
        if row >= currentRoute.wildcards.count {
            view?.textField?.selectText(nil)
        }
        
        return view
    }
    
    func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int) {
        
    }
}

extension RouteContentViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateSegementedControl()
    }
}
