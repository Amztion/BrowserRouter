//
//  RouteListViewController.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/10/27.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import ReSwift


class RouteListViewController: NSViewController {

    private enum SegmentedControlIndex: Int {
        case add
        case remove
    }
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    
    private var routeList = Route.emptyList
    
    private var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configSegmentedControl()
        
        mainStore.subscribe(self)
    }
    
    private func configSegmentedControl() {
        updateSegmentedControl()
    }
    
    @IBAction func segmentedSelectedChanged(_ sender: NSSegmentedControl) {
        guard let selectedIndex = SegmentedControlIndex(rawValue: sender.selectedSegment) else {
            // TODO: Error
            print("error type")
            
            return
        }
        
        switch selectedIndex {
        case .add:
            add()
        case .remove:
            remove()
        }
    }
}

extension RouteListViewController {
    fileprivate func updateSegmentedControl() {
        segmentedControl.setEnabled(!(tableView.selectedRow == -1), forSegment: SegmentedControlIndex.remove.rawValue)
    }
    
    func add() {
        mainStore.dispatch(RouteListAddAction(route: Route(browser: Browser.all.first!, pattern: EmptyPattern)))
    }
    
    func remove() {
        let selectedIndex = tableView.selectedRow
        
        if selectedIndex != NonselectedIndex {
            mainStore.dispatch(RouteListRemoveAction(route: routeList[selectedIndex], index: selectedIndex))
        }
    }
}

extension RouteListViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = RouteState
    
    func newState(state: RouteState) {
        routeList = state.routes
        tableView.reloadData()
  
        if state.selectedIndex != NonselectedIndex {
            tableView.selectRowIndexes(IndexSet(integer: state.selectedIndex), byExtendingSelection: false)
        }
    }
}

extension RouteListViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if selectedIndex != tableView.selectedRow {
            selectedIndex = tableView.selectedRow
            
            let route = tableView.selectedRow == NonselectedIndex ? NonselectedRoute : routeList[tableView.selectedRow]
            mainStore.dispatch(RouteListSelectAction(route: route, index: tableView.selectedRow))
        }
        
        updateSegmentedControl()
    }
}

extension RouteListViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return routeList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: RouteListTableCellView.CellViewIdentifier.RouteList), owner: self) as? RouteListTableCellView
        view?.set(item: RouteTableItem(route: routeList[row]))
        
        return view
    }
}
