//
//  ProductCollectionCell.swift
//  FakeShop
//
//  Created by 이태형 on 3/1/25.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {
    static let identifier: String = String(describing: ProductCollectionCell.self)
    
    let preview: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let ratingLabel: UILabel = UILabel()
    let priceLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview("SearchProductsVC"){
    return UINavigationController(rootViewController: SearchProductsVC())
}

//MARK: - Function
extension ProductCollectionCell{
    
}

//MARK: - SETUP
extension ProductCollectionCell{
    private func setViewConfig(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        preview.contentMode = .scaleAspectFit
        
        [titleLabel].forEach{
            $0.font = .NanumGothic(type: .Bold, size: 20)
            $0.textColor = .black
        }
        
        [ratingLabel].forEach{
            $0.font = .NanumGothic(type: .Regular, size: 14)
            $0.textColor = .black
        }
        
        [priceLabel].forEach{
            $0.font = .NanumGothic(type: .Bold, size: 20)
            $0.textColor = .black
        }
    }
    
    private func setUI(){
        let labelStack: UIStackView = UIStackView(arrangedSubviews: [titleLabel, ratingLabel, priceLabel])
        [labelStack].forEach{
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.alignment = .trailing
            $0.spacing = 8
        }
        
        [preview, labelStack].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            preview.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            preview.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            preview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            preview.widthAnchor.constraint(equalTo: preview.heightAnchor),
            
            labelStack.topAnchor.constraint(equalTo: preview.bottomAnchor, constant: 16),
            labelStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            labelStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            labelStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
    }
}
