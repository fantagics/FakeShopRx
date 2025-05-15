//
//  NoticeImageCell.swift
//  FakeShop
//
//  Created by 이태형 on 2/10/25.
//

import UIKit

class NoticeImageCell: UICollectionViewCell{
    static let identifier: String = String(describing: NoticeImageCell.self)
    
    let imageView: UIImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [imageView].forEach{
            $0.backgroundColor = .gray
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
