//
//  ProductInfoTableCell.swift
//  FakeShop
//
//  Created by 이태형 on 2/21/25.
//

import UIKit

class ProductInfoTableCell: UITableViewCell {
    static let identifier: String = String(describing: ProductInfoTableCell.self)
    
    var starArray: [UIImageView] = []
    
    let category: UILabel = UILabel()
    let title: UILabel = UILabel()
    private let ratingStack: UIStackView = UIStackView()
    let ratingCount: UILabel = UILabel()
    let price: UILabel = UILabel()
    private let underline: UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Function
extension ProductInfoTableCell{
    func setRatingStar(rate: Double){
        let v = Int(round(rate * 2))
        for idx in 0..<5{
            starArray[idx].tintColor = .primary
            if v / ((idx + 1) * 2) > 0{
                starArray[idx].image = UIImage(systemName: "star.fill")
            } else if v % (idx * 2) == 1{
                starArray[idx].image = UIImage(systemName: "star.leadinghalf.filled")
            } else{
                starArray[idx].image = UIImage(systemName: "star")
            }
        }
    }
    
}

//MARK: - SETUP
extension ProductInfoTableCell{
    private func setup(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        self.backgroundColor = .white
        
        for i in 0..<5{
            ratingStack.addArrangedSubview(UIImageView())
            starArray.append(ratingStack.subviews[i] as? UIImageView ?? UIImageView())
        }
        
        [category].forEach{
            $0.textColor = .gray
            $0.font = .NanumGothic(type: .Regular, size: 12)
            $0.text = "CATEGORY"
        }
        [title].forEach{
            $0.font = .NanumGothic(type: .Bold, size: 20)
            $0.numberOfLines = 2
            $0.text = "TITLE"
            $0.textColor = .black
        }
        [ratingStack].forEach{
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 0
        }
        [ratingCount].forEach{
            $0.textColor = .gray
            $0.font = .NanumGothic(type: .Regular, size: 12)
            $0.text = "(-1)"
        }
        [price].forEach{
            $0.font = .NanumGothic(type: .Bold, size: 18)
            $0.text = "$ 0"
            $0.textColor = .black
        }
        underline.backgroundColor = .darkGray
    }
    
    private func setUI(){
        [category, title, ratingStack, ratingCount, price, underline].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            category.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            category.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            category.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -8),
            
            title.topAnchor.constraint(equalTo: category.bottomAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: category.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            ratingStack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            ratingStack.leadingAnchor.constraint(equalTo: category.leadingAnchor),
            ratingStack.heightAnchor.constraint(equalToConstant: 20),
            
            ratingCount.centerYAnchor.constraint(equalTo: ratingStack.centerYAnchor),
            ratingCount.leadingAnchor.constraint(equalTo: ratingStack.trailingAnchor, constant: 8),
            ratingCount.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -16),
            
            price.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 8),
            price.leadingAnchor.constraint(equalTo: category.leadingAnchor),
            
            underline.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 8),
            underline.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            underline.heightAnchor.constraint(equalToConstant: 2),
            underline.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
