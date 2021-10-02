//
//  ViewController.swift
//  HRC
//
//  Created by 윤태민 on 9/30/21.
//

//  Refrenece:
//  - https://guides.codepath.com/ios/Table-View-Guide
//  - Pull to refresh: https://cocoacasts.com/how-to-add-pull-to-refresh-to-a-table-view-or-collection-view

import UIKit

class ViewController: UIViewController {
    
    var tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    let tableViewCellId = "tableViewCellId"
    private let sections: [String] = ["Network", "Controls", "Test"]
    private let networkSection: [String] = ["Status"]
    private let controlsSection: [String] = ["Close the window", "Turn on the airconditioner"]
    private let testSection: [String] = [" ", " "]
    
    var isConnected: Bool = false
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        //auto layout for the table view
        let views = ["view": view!, "tableView" : tableView]
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: views as [String : Any])
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: views as [String : Any])
        NSLayoutConstraint.activate(allConstraints)
        
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "HRC"
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: tableViewCellId)
        tableView.tableFooterView = UIView()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        print("Pulled")
        fetchData(url: "")
    }
    
    // fetch data from sever
    private func fetchData(url: String) -> Void {
        isConnected.toggle()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension ViewController: UITableViewDelegate {
    // To make cell not selectable
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].uppercased()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return networkSection.count
        }
        else if section == 1 {
            return controlsSection.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell
        
        if indexPath.section == 0 {
            cell = CustomTableViewCell(style: .default, reuseIdentifier: nil, label: UILabel())
            cell.title.text = "\(networkSection[indexPath.row])"
            cell.label?.text = isConnected ? "Connected" : "Failed"
        }
        else if indexPath.section == 1 {
            cell = CustomTableViewCell(style: .default, reuseIdentifier: nil, toggle: UISwitch())
            cell.title.text = "\(controlsSection[indexPath.row])"
        }
        else {
            cell = CustomTableViewCell(style: .default, reuseIdentifier: nil)
        }
        
        return cell
    }
}


