//
//  RecommendSectionHeader.swift
//  FakeShop
//
//  Created by 이태형 on 2/10/25.
//

import UIKit

class RecommendSectionHeader: UICollectionReusableView{
    static let identifier: String = String(describing: RecommendSectionHeader.self)
    
    let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        [titleLabel].forEach{
            $0.textColor = .black
            $0.font = .NanumGothic(type: .Bold, size: 20)
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
