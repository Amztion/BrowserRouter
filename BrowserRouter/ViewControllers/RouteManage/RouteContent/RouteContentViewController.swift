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
    
    private var addingIndex: Int? {
        didSet {
            updateSegementedControl()
        }
    }
    
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
            guard let item = browserSelectPopUpButton.item(withTitle: browser.identifier) else {
                print("browser pop up item with identifier \(browser.identifier) is nil")
                return
            }
            
            item.title = browser.name
            item.image = browser.icon
        }
    }
    
    private func configSegmentedControl() {
        updateSegementedControl()
    }
    
    @IBAction func browserSelectionDidChanged(_ sender: NSPopUpButton) {
        guard let selectedItem = sender.selectedItem, let index = sender.itemArray.index(of: selectedItem) else {
            //TODO: Error
            return
        }
        
        guard index < Browser.all.count else {
            // TODO: Error Message
            print("Error message")
            return
        }
        
        let selectedBrowser = Browser.all[index]
        
        let route = Route(browser: selectedBrowser, wildcards: currentRoute?.wildcards ?? EmptyWildcard)
        currentRoute = route
        
        mainStore.dispatch(RouteListModifyAction(route: route, index: selectedIndex))
    }
    
    @IBAction func contentTextFieldDidChanged(_ sender: NSTextField) {
        let selected = tableView.selectedRow
        
        guard selected != NonselectedIndex else {
            print("nonselected index")
            return
        }
        
        if let addingIndex = addingIndex {
            endAdding()
        } else {
            
        }
    }
    
    @IBAction func segmentedControlClicked(_ sender: NSSegmentedControl) {
        guard let selectedIndex = SegmentedControlIndex(rawValue: sender.selectedSegment) else {
            //TODO: Error
            print("selected index error")
            return
        }
        
        switch selectedIndex {
        case .add:
            beginAdding()
        case .remove:
            remove()
        }
    }
}

extension RouteContentViewController {
    fileprivate func updateSegementedControl() {
        segmentedControl.setEnabled(!(tableView.selectedRow == -1), forSegment: SegmentedControlIndex.remove.rawValue)
        segmentedControl.setEnabled(addingIndex == nil, forSegment: SegmentedControlIndex.add.rawValue)
    }
    
    func beginAdding() {
        guard let currentRoute = currentRoute else {
            return
        }
        
        guard addingIndex == nil else {
            return
        }
        
        addingIndex = currentRoute.wildcards.count
        tableView.insertRows(at: IndexSet(integer: addingIndex!), withAnimation: .effectGap)
    }
    
    func endAdding() {
        guard let addingIndex = addingIndex else {
            print("adding index is nil")
            return
        }
        
        guard let currentRoute = currentRoute else {
            print("current route is nil")
            return
        }
        
        guard let view = tableView.rowView(atRow: addingIndex, makeIfNecessary: false)?.view(atColumn: 0) as? RouteContentListTableCellView else {
            print("adding view is nil")
            return
        }
        
        guard let text = view.textField?.stringValue else {
            print("added text is nil")
            return
        }
        
        if text.count > 0 {
            if let newWildCard = Pattern(url: text) {
                var wildcards = currentRoute.wildcards
                wildcards.append(newWildCard)
                
                mainStore.dispatch(RouteListModifyAction(
                    route: Route(browser: currentRoute.browser, wildcards: wildcards),
                    index: selectedIndex
                ))
            }
        }
        
        tableView.removeRows(at: IndexSet(integer: addingIndex), withAnimation: .effectFade)
        self.addingIndex = nil
    }
    
    func remove() {
        guard let currentRoute = currentRoute else {
            return
        }
        
        guard tableView.selectedRow > NonselectedIndex && tableView.selectedRow < currentRoute.wildcards.count else {
            print("remove index error")
            return
        }
        
        var wildcards = currentRoute.wildcards
        wildcards.remove(at: tableView.selectedRow)
        
        mainStore.dispatch(RouteListModifyAction(
            route: Route(browser: currentRoute.browser, wildcards: wildcards),
            index: selectedIndex
        ))
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
            content: row < currentRoute.wildcards.count ? currentRoute.wildcards[row].url : ""
        ))
        
        return view
    }
    
    func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int) {
        guard currentRoute != nil else {
            return
        }
        
        guard let view = rowView.view(atColumn: 0) as? RouteContentListTableCellView else {
            //TODO: Error
            print("Didn't add")
            
            return
        }
        
        if let addingIndex = addingIndex, row == addingIndex {
            view.textField?.selectText(nil)
            view.textField?.becomeFirstResponder()
            tableView.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
        }
    }
}

extension RouteContentViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateSegementedControl()
    }
}
