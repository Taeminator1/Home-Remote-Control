//
//  ViewController.swift
//  HRC
//
//  Created by 윤태민 on 9/30/21.
//

//  Initial view for inital excution of the Application:
//  - Network Status
//  - Controls

//  Refrenece:
//  - https://guides.codepath.com/ios/Table-View-Guide
//  - Pull to refresh: https://cocoacasts.com/how-to-add-pull-to-refresh-to-a-table-view-or-collection-view

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    private let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    private let tableViewCellId = "tableViewCellId"
    
    private let sectionData: [Section] = ModelData.getSectionData()
    
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
        appDelegate.wkWebView.load(appDelegate.request)
        _ = fetchData(appDelegate.url)
            .observe(on: MainScheduler.instance)              // DispatchQueue.main.async { } 역할
            .subscribe { [self] event in
                var buttonStates: [Bool] = buttons.map { $0.isOn }
                
                switch event {
                case .next(let htmlFromURL):
                    isConnected = true
                    // Get String starting with "\'label" in HTML from server
                    buttonStates = getButtonStatesInHtml(target: "\'label", html: htmlFromURL)
                case .completed:
                    print("Loaded")
                case .error:
                    isConnected = false
                }
                
                for i in 0 ..< self.sectionData[1].contents.count {
                    self.buttons[i].isOn = buttonStates[i]
                }
            }
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
        _ = fetchData(appDelegate.url)
            .observe(on: MainScheduler.instance)              // DispatchQueue.main.async { } 역할
            .subscribe { [self] event in
                var buttonStates: [Bool] = buttons.map { $0.isOn }
                
                switch event {
                case .next(let htmlFromURL):
                    isConnected = true
                    // Get String starting with "\'label" in HTML from server
                    buttonStates = getButtonStatesInHtml(target: "\'label", html: htmlFromURL)
                case .completed:
                    print("Loaded and Pulled")
                case .error:
                    isConnected = false
                }
                
                for i in 0 ..< self.sectionData[1].contents.count {
                    self.buttons[i].isOn = buttonStates[i]
                }
                self.refreshControl.endRefreshing()
            }
    }
    
    @objc func toggleTouched(_ sender: UISwitch) {
        print("Button\(sender.tag + 1) is changed")
        javaScriptFunction(index: sender.tag)
    }
    
    private func javaScriptFunction(index: Int) -> Void {
        // Refer to app.js file in Server folder.
        print(appDelegate.wkWebView)
        appDelegate.wkWebView.evaluateJavaScript("buttonClicked('btn\(index + 1)');", completionHandler: { (result, error) in
            if let anError = error {
                print("evaluateJavaScript infoUpdate Error \(anError.localizedDescription)")
            }
        })
    }
    
    // fetch data from sever
    private func fetchData(_ url: String) -> Observable<String> {
        return Observable.create { emitter in
            let url = URL(string: url)!
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard error == nil else {
                    emitter.onError(error!)
                    return
                }
                
                if let tmpData = data, let htmlFromURL = String(data: tmpData, encoding: .utf8) {
                    emitter.onNext(htmlFromURL)
                }
                
                emitter.onCompleted()
            }
            task.resume()
            
            return Disposables.create() {
                task.cancel()
            }
        }
    }
    
    private func getButtonStatesInHtml(target: String, html: String) -> [Bool] {
        var index: Int = 0
        var buttonStates: [Bool] = []
        
        // Get String starting with "\'label" in HTML from server
        for i in 0 ... html.count {
            if html[i ..< (i + target.count)] == target {
                buttonStates.append(html[(i + 10) ..< (i + 15)] == "true ")
                
                index += 1
                if index == self.sectionData[1].contents.count { break }
            }
        }
        
        return buttonStates
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
        return sectionData[section].section.uppercased()
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


