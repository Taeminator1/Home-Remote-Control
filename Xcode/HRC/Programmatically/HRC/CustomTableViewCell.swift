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
    let content = UILabel()
//    let toggle: = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        content.translatesAutoresizingMaskIntoConstraints = false
//        toggle.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)
        contentView.addSubview(content)
//        contentView.addSubview(toggle)
        
        let views = [
            "title"     : title,
            "content"   : content,
//            "toggle"    : toggle,
        ]
        
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[content]-|", options: [], metrics: nil, views: views)
//        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[toggle]-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-[content]-|", options: [], metrics: nil, views: views)
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
