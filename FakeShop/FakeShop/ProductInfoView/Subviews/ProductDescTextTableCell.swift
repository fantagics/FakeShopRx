//
//  ProductDescTextTableCell.swift
//  FakeShop
//
//  Created by 이태형 on 2/21/25.
//

import UIKit

class ProductDescTextTableCell: UITableViewCell {
    static let identifier: String = String(describing: ProductDescTextTableCell.self)
    
    let desc: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SETUP
extension ProductDescTextTableCell{
    private func setup(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        self.backgroundColor = .white
        desc.numberOfLines = 0
        desc.font = .NanumGothic(type: .Regular, size: 20)
        desc.textColor = .darkGray
        desc.text = "DESCRIPTION"
    }
    
    private func setUI(){
        desc.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(desc)
        
        NSLayoutConstraint.activate([
            desc.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            desc.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            desc.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            desc.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
    }
}
