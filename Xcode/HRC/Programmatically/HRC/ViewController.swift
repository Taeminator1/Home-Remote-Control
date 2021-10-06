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
    
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    private let tableViewCellId = "tableViewCellId"
    
    private let sectionData: [Section] = ModelData.getSectionData()
    private let sections: [String] = ["Network", "Controls"]
    private let networkSection: [String] = ["Status"]
    private let controlsSection: [String] = ["Close the window", "Turn on the airconditioner"]
    
    private let refreshControl = UIRefreshControl()
    private var buttons: [UISwitch] = []
    private var isConnected: Bool = false {
        willSet {
            buttons.forEach { $0.isEnabled = newValue }
        }
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
        AppDelegate.wkWebView.load(AppDelegate.request)
        fetchData(url: PersonalInfo.strURL)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        setupAutoLayout()
        setupNavigationBar()
        setupTableView()
        
        for index in 0 ..< sectionData[1].contents.count {
            let button = UISwitch()
            button.addTarget(self, action: #selector(toggleTouched(_:)), for: .valueChanged)
            button.tag = index
            buttons.append(button)
        }
    }
    
    private func setupAutoLayout() {
        let views = [
            "view"      : view!,
            "tableView" : tableView,
        ]
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(allConstraints)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "HRC"
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: tableViewCellId)
        tableView.tableFooterView = UIView()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        print("Pulled")
        fetchData(url: AppDelegate.url)
        refreshControl.endRefreshing()
    }
    
    @objc func toggleTouched(_ sender: UISwitch) {
        print("Button\(sender.tag + 1) is changed")
        javaScriptFunction(index: sender.tag)
    }
    
    private func javaScriptFunction(index: Int) -> Void {
        // Refer to app.js file in Server folder.
        print(AppDelegate.wkWebView)
        AppDelegate.wkWebView.evaluateJavaScript("buttonClicked('btn\(index + 1)');", completionHandler: { (result, error) in
            if let anError = error {
                print("evaluateJavaScript infoUpdate Error \(anError.localizedDescription)")
            }
        })
    }
    
    // fetch data from sever
    private func fetchData(url: String) -> Void {
        var index: Int = 0
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                DispatchQueue.main.async {      // UI 관련 작업을 메인 쓰레드로 보내기
                    self.isConnected = false
                }
                return
            }
            
            DispatchQueue.main.async {      // UI 관련 작업을 메인 쓰레드로 보내기
                self.isConnected = true
            }
            
            var tmpButtonStates: [Bool] = []
            if let htmlFromURL = String(data: data, encoding: .utf8) {      // Get String starting with "\'label" in HTML from server
                for i in 0 ... htmlFromURL.count {
                    if htmlFromURL[i ..< (i + 6)] == "\'label" {
                        tmpButtonStates.append(htmlFromURL[(i + 10) ..< (i + 15)] == "true ")
                        
                        index += 1
                        if index == self.sectionData[1].contents.count { break }
                    }
                }
            }
            
            DispatchQueue.main.async {      // UI 관련 작업을 메인 쓰레드로 보내기
                for i in 0 ..< self.sectionData[1].contents.count {
                    self.buttons[i].isOn = tmpButtonStates[i]
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
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionData[section].title.uppercased()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell           // 각 셀마다 형식이 다를 수 있어 tableView.dequeueReusableCell 사용 안 함
        
        if indexPath.section == 0 {
            cell = CustomTableViewCell(style: .default, reuseIdentifier: nil, label: UILabel())
            cell.title.text = sectionData[indexPath.section].contents[indexPath.row]
            cell.label?.text = isConnected ? "Connected" : "Failed"
        }
        else if indexPath.section == 1 {
            cell = CustomTableViewCell(style: .default, reuseIdentifier: nil, toggle: buttons[indexPath.row])
            cell.title.text = sectionData[indexPath.section].contents[indexPath.row]
        }
        else {
            cell = CustomTableViewCell(style: .default, reuseIdentifier: nil)
        }
        
        cell.selectionStyle = .none             // 눌려도 아무 애니메이션 없음
        return cell
    }
}


