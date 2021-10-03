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
    
    var isConnected: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
        fetchData(url: PersonalInfo.strURL)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
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
        fetchData(url: PersonalInfo.strURL)
        refreshControl.endRefreshing()
    }
    
    // fetch data from sever
    private func fetchData(url: String) -> Void {
//        var index: Int = 0
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                DispatchQueue.main.async {      // UI 작업 메인 쓰레드로 보내기
                    self.isConnected = false
                }
                return
            }
            
            DispatchQueue.main.async {      // UI 작업 메인 쓰레드로 보내기
                self.isConnected = true
            }
            if let htmlFromURL = String(data: data, encoding: .utf8) {      // Get String starting with "\'label" in HTML from server
                for i in 0 ... htmlFromURL.count {
                    if htmlFromURL[i ..< (i + 6)] == "\'label" {
//                        buttonStates[index]  = htmlFromURL[(i + 10) ..< (i + 15)] == "true " ? true : false
//
//                        index += 1
//                        if index == buttonStates.count { break }
                    }
                }
            }
        }
        task.resume()
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
            let toggle = UISwitch()
            toggle.addTarget(self, action: #selector(toggleTouched(_:)), for: .valueChanged)
            cell = CustomTableViewCell(style: .default, reuseIdentifier: nil, toggle: toggle)
            cell.title.text = "\(controlsSection[indexPath.row])"
        }
        else {
            cell = CustomTableViewCell(style: .default, reuseIdentifier: nil)
        }
        
        return cell
    }
    
    @objc func toggleTouched(_ sender: UISwitch) {
        if sender.isOn {
            print("a")
        }
        else {
            print("b")
        }
    }
}


