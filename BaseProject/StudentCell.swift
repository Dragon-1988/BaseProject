//
//  StudentCell.swift
//  BaseProject
//
//  Created by Michael Seven on 3/28/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

import UIKit

class StudentCell: UITableViewCell {
    
    static let reuseIdentifier = "StudentCell"

    let nameLb = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initComponents()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initComponents() {
        self.contentView.addSubview(nameLb)
        nameLb.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(30)
        }
        nameLb.text = "abc"
    }
    
    func bindingData(student: StudentModel) {
        self.nameLb.text = "\(student.name)"
    }

}
