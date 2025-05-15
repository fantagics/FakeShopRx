//
//  ProductImageTableCell.swift
//  FakeShop
//
//  Created by 이태형 on 2/21/25.
//

import UIKit

class ProductImageTableCell: UITableViewCell {
    static let identifier: String = String(describing: ProductImageTableCell.self)
    
    let image: UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SETUP
extension ProductImageTableCell{
    private func setup(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        self.backgroundColor = .white
        image.contentMode = .scaleAspectFit
    }
    
    private func setUI(){
        image.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: self.topAnchor),
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.5625),
            image.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
