//
//  PurchaseActionSheet.swift
//  FakeShop
//
//  Created by 이태형 on 2/24/25.
//

import UIKit

class PurchaseBottomSheet: UIView {
    
    private var itemPrice: Double = 0
    private var itemCount: Int = 1
    private let titleLabel: UILabel = UILabel()
    private let priceLabel: UILabel = UILabel()
    private let countView: UIView = UIView()
    private let countLabelView: UIView = UIView()
    private let countLabel: UILabel = UILabel()
    private let countPlusButton: UIButton = UIButton()
    private let countMinusButton: UIButton = UIButton()
    private let submitButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview("ProductInfoVC"){
    let vc = ProductInfoVC()
    vc.product = Common.shared.dummyProduct
    return UINavigationController(rootViewController: vc)
}

//MARK: - Function
extension PurchaseBottomSheet{
    func resetUI(product: Product, type: Purchase){
        titleLabel.text = product.title
        itemPrice = product.price
        priceLabel.text = itemPrice.toCurrencyFormat()
        submitButton.setTitle(type.str.localized(), for: .normal)
        itemCount = 1
        countLabel.text = "\(itemCount)"
    }
    
    @objc private func didTapCountButton(_ sender: UIButton){
        if sender == countPlusButton{
            guard itemCount < 999 else{return}
            itemCount += 1
        } else if sender == countMinusButton{
            guard itemCount > 1 else{return}
            itemCount -= 1
        }
        countLabel.text = "\(itemCount)"
        priceLabel.text = (itemPrice * Double(itemCount)).toCurrencyFormat()
    }
}

//MARK: - SETUP
extension PurchaseBottomSheet{
    private func setup(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        [self].forEach{
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 32
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        [titleLabel].forEach{
            $0.numberOfLines = 1
            $0.font = .NanumGothic(type: .Bold, size: 24)
            $0.textColor = .black
        }
        [priceLabel].forEach{
            $0.textColor = .primary
            $0.font = .NanumGothic(type: .Bold, size: 24)
        }
        [countView].forEach{
            $0.backgroundColor = .primary
            $0.layer.cornerRadius = 25
        }
        [countLabelView].forEach{
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
        }
        [countLabel].forEach{
            $0.font = .NanumGothic(type: .Bold, size: 24)
            $0.textColor = .primary
            $0.textAlignment = .center
            $0.text = "\(itemCount)"
        }
        countMinusButton.setImage(UIImage(systemName: "minus"), for: .normal)
        countPlusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        [countMinusButton, countPlusButton].forEach{
            $0.tintColor = .white
            $0.addTarget(self, action: #selector(didTapCountButton(_:)), for: .touchUpInside)
        }
        [submitButton].forEach{
            $0.backgroundColor = .primary
            $0.tintColor = .white
            $0.layer.cornerRadius = 16
            $0.titleLabel?.font = .NanumGothic(type: .Bold, size: 24)
        }
    }
    //UI
    private func setUI(){
        [titleLabel, priceLabel, countView, submitButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        [countMinusButton, countPlusButton, countLabelView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            countView.addSubview($0)
        }
        [countLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            countLabelView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            countView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            countView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            countView.widthAnchor.constraint(equalToConstant: 160),
            countView.heightAnchor.constraint(equalToConstant: 50),
            
            countLabelView.centerXAnchor.constraint(equalTo: countView.centerXAnchor),
            countLabelView.centerYAnchor.constraint(equalTo: countView.centerYAnchor),
            countLabelView.widthAnchor.constraint(equalToConstant: 60),
            countLabelView.heightAnchor.constraint(equalToConstant: 40),
            
            countLabel.topAnchor.constraint(equalTo: countLabelView.topAnchor),
            countLabel.bottomAnchor.constraint(equalTo: countLabelView.bottomAnchor),
            countLabel.leadingAnchor.constraint(equalTo: countLabelView.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: countLabelView.trailingAnchor),
            
            countPlusButton.topAnchor.constraint(equalTo: countView.topAnchor),
            countPlusButton.bottomAnchor.constraint(equalTo: countView.bottomAnchor),
            countPlusButton.leadingAnchor.constraint(equalTo: countLabelView.trailingAnchor),
            countPlusButton.trailingAnchor.constraint(equalTo: countView.trailingAnchor),
            
            countMinusButton.topAnchor.constraint(equalTo: countView.topAnchor),
            countMinusButton.bottomAnchor.constraint(equalTo: countView.bottomAnchor),
            countMinusButton.leadingAnchor.constraint(equalTo: countView.leadingAnchor),
            countMinusButton.trailingAnchor.constraint(equalTo: countLabelView.leadingAnchor),
            
            submitButton.topAnchor.constraint(equalTo: countView.bottomAnchor, constant: 24),
            submitButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.heightAnchor.constraint(equalToConstant: 400),
        ])
    }
}
