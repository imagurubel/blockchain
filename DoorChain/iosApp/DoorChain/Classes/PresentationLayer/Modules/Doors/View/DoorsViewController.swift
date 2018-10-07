//
//  DoorsDoorsViewController.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 06/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

class DoorsViewController: UIViewController {

    var output: DoorsViewOutput!

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    var doors = [Door]()
    var isOwner = false
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(DoorsViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        tableView.refreshControl = refreshControl
        
        title = "Doors"
        
        output.viewIsReady()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        output.actionLoadData()
    }
}

extension DoorsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DoorsTableViewCell") as? DoorsTableViewCell {
            
            let door = doors[indexPath.row]
            cell.door = door
            cell.isOwner = isOwner
            cell.delegate = self
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doors.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let door = doors[indexPath.row]
        output.actionOpenDoor(door: door)
    }
}

extension DoorsViewController: DoorsTableViewCellDelegate {
    
    func deleteDoor(door: Door) {
        output.actionDeleteDoor(door: door)
    }
    
    func editDoor(door: Door) {
        output.actionEditDoor()
    }
}

// MARK: - DoorsViewInput

extension DoorsViewController: DoorsViewInput {
    
    func setupInitialState(doors: [Door], isOwner: Bool) {
        self.doors = doors
        self.isOwner = isOwner
        tableView.reloadData()
    }
    
    func showLoading() {
        refreshControl.beginRefreshing()
    }
    
    func hideLoading() {
        refreshControl.endRefreshing()
    }
    
    func showError(message: String) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
