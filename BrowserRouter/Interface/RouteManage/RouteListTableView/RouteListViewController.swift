//
//  RouteListViewController.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/10/27.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

class RouteListViewController: NSViewController {
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configSegmentedControl()
    }
    
    private func configSegmentedControl() {

    }
    
 
    @IBAction func segmentedSelectedChanged(_ sender: NSSegmentedControl) {
        print(sender.selectedSegment)
    }
    
}

extension RouteListViewController {

}

extension RouteListViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
}

extension RouteListViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return RouteManager.allRoutes.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.make(withIdentifier: RouteTableCellView.CellViewIdentifier.RouteList, owner: self) as? RouteTableCellView
        view?.set(item: RouteTableItem(route: RouteManager.allRoutes[row]))
        
        return view
    }
}
