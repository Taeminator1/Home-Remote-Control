//
//  ViewController.swift
//  HRC
//
//  Created by 윤태민 on 9/30/21.
//

import UIKit

class ViewController: UIViewController {
    
    var tableView = UITableView()
    let tableViewCellId = "tableViewCellId"
    private let sections: [String] = ["Network", "Controls", "Test"]
    private let networkSection: [String] = ["Status"]
    private let controlsSection: [String] = ["Close the window", "Turn on the airconditioner"]
    private let testSection: [String] = ["", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() {
        title = "HRC"
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellId)
        tableView.tableFooterView = UIView()
        
        view = tableView
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
        else if section == 2 {
            return testSection.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "\(networkSection[indexPath.row])"
        }
        else if indexPath.section == 1 {
            cell.textLabel?.text = "\(controlsSection[indexPath.row])"
        }
        else if indexPath.section == 2 {
            cell.textLabel?.text = "\(testSection[indexPath.row])"
        }
        
        return cell
    }
}

