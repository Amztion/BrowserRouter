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
    
    private var routeList = [Route]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configSegmentedControl()
        
        mainStore.subscribe(self)
    }
    
    private func configSegmentedControl() {
        updateSegmentedControl()
    }
    
    @IBAction func segmentedSelectedChanged(_ sender: NSSegmentedControl) {
        if let selectedIndex = SegmentedControlIndex(rawValue: sender.selectedSegment) {
            switch selectedIndex {
            case .add:
                add()
            case .remove:
                remove()
            }
        } else {
            print("error type")
        }
    }
}

extension RouteListViewController {
    fileprivate func updateSegmentedControl() {
        let enabled = !(tableView.selectedRow == -1)
        
        segmentedControl.setEnabled(enabled, forSegment: SegmentedControlIndex.remove.rawValue)
    }
    
    func add() {
        mainStore.dispatch(RouteListAddAction(route: Route(browser: Browser.all.first!, wildcards: [Wildcard]())))
    }
    
    func remove() {
        let selectedIndex = tableView.selectedRow
        
        if selectedIndex > -1 {
            mainStore.dispatch(RouteListRemoveAction(route: routeList[selectedIndex], index: selectedIndex))
        }
    }
}

extension RouteListViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = RouteState
    
    func newState(state: RouteState) {
        routeList = state.routes
        tableView.reloadData()
  
        if let selectedIndex = state.selectedIndex {
            tableView.selectRowIndexes(IndexSet(integer: selectedIndex), byExtendingSelection: false)
            updateSegmentedControl()
        }
    }
}

extension RouteListViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
            return 50
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = (notification.object as! NSTableView).selectedRow
        
        if self.tableView.selectedRow != selectedRow {
            mainStore.dispatch(RouteListSelectAction(route: RouteManager.shared.routes[selectedRow], index: selectedRow))
            updateSegmentedControl()
        }
    }
}

extension RouteListViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return routeList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: RouteTableCellView.CellViewIdentifier.RouteList), owner: self) as? RouteTableCellView
        view?.set(item: RouteTableItem(route: routeList[row]))
        
        return view
    }
}
