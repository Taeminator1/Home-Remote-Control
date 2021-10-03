//
//  CustomTableViewCell.swift
//  HRC
//
//  Created by 윤태민 on 10/2/21.
//

//  References:
//  - https://www.mysamplecode.com/2019/04/ios-swift-create-UITableView-custom-UITableViewCell.html
//  - https://softauthor.com/ios-uitableview-programmatically-in-swift/#implement-uitableviewdatasource-protocol-methods
//  - https://www.youtube.com/watch?v=dLm_g4GarLs

import UIKit

class CustomTableViewCell: UITableViewCell {

    let title = UILabel()
    var label: UILabel?
    var toggle: UISwitch?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)
        
        let views = [
            "title"     : title,
        ]
        
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(allConstraints)
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, label: UILabel) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.label = label
        
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.label!.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(self.title)
        contentView.addSubview(self.label!)
        
        // For auto layout of the cell
        let views = [
            "title"     : self.title,
            "label"     : self.label,
        ]
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]-|", options: [], metrics: nil, views: views as [String : Any])
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options: [], metrics: nil, views: views as [String : Any])
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-[label]-|", options: [], metrics: nil, views: views as [String : Any])
        NSLayoutConstraint.activate(allConstraints)
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, toggle: UISwitch) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.toggle = toggle
        
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.toggle!.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(self.title)
        contentView.addSubview(self.toggle!)

        let views = [
            "title"     : self.title,
            "toggle"     : self.toggle,
        ]
        
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]-|", options: [], metrics: nil, views: views as [String : Any])
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[toggle]-|", options: [], metrics: nil, views: views as [String : Any])
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-[toggle]-|", options: [], metrics: nil, views: views as [String : Any])
        NSLayoutConstraint.activate(allConstraints)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
