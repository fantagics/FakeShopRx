//
//  RecommendItemCell.swift
//  FakeShop
//
//  Created by 이태형 on 2/10/25.
//

import UIKit

class RecommendItemCell: UICollectionViewCell {
    static let identifier: String = String(describing: RecommendItemCell.self)
    
    private let shadowView: UIView = UIView()
    let imageView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let priceLabel: UILabel = UILabel()
    let ratingLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SETUP
extension RecommendItemCell{
    private func setup(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        [imageView].forEach{
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }
        [shadowView].forEach{
            $0.backgroundColor = .black.withAlphaComponent(0.3)
            $0.layer.cornerRadius = 20
        }
        [titleLabel].forEach{
            $0.text = "제품명"
            $0.font = .NanumGothic(type: .Regular, size: 16)
            $0.textColor = .black
        }
        [priceLabel].forEach{
            $0.text = "$199.9"
            $0.font = .NanumGothic(type: .Regular, size: 16)
            $0.textColor = .black
        }
        [ratingLabel].forEach{
            $0.text = "⭐️ 4.6 / 🛒 400"
            $0.font = .NanumGothic(type: .Regular, size: 10)
            $0.textColor = .black
        }
    }
    
    private func setUI(){
        let labelStack: UIStackView = UIStackView(arrangedSubviews: [titleLabel, priceLabel, ratingLabel])
        [labelStack].forEach{
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .equalSpacing
            $0.spacing = 6
        }
        [shadowView, imageView, labelStack].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            shadowView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor, constant: 0.5),
            shadowView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 0.5),
            shadowView.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: 1),
            shadowView.heightAnchor.constraint(equalTo: imageView.heightAnchor, constant: 1),
            
            labelStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            labelStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            labelStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            labelStack.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -10),
        ])
    }
}
