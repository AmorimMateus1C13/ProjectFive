//
//  CellTableViewTableViewCell.swift
//  ProjectFive
//
//  Created by Mateus Amorim on 12/09/22.
//

import UIKit
import SnapKit

class CellTableViewTableViewCell: UITableViewCell {
    
    static let identifier = "Work"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 21)
        return label
    }()
    
}


extension CellTableViewTableViewCell: ViewConfiguration {
    func viewHierarchy() {
        addSubview(label)
    }
    
    func setupContrants() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
