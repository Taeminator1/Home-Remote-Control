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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellId)
        tableView.tableFooterView = UIView()
        
        view = tableView
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath)
        
        return cell
    }
}

