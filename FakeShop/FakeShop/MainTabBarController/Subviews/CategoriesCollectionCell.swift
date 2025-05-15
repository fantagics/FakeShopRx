//
//  CategoriesCollectionCell.swift
//  FakeShop
//
//  Created by 이태형 on 2/3/25.
//

import UIKit

class CategoriesCollectionCell: UICollectionViewCell{
    static let identifier: String = String(describing: CategoriesCollectionCell.self)
    
    let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#Preview("MainTabBarController"){
    return MainTabBarController()
}

extension CategoriesCollectionCell{
    private func setAttribute(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        
        [titleLabel].forEach{
            $0.textColor = .primary
            $0.font = .NanumGothic(type: .Bold, size: 16)
        }
    }
    
    private func setUI(){
        [titleLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
        ])
    }
}
