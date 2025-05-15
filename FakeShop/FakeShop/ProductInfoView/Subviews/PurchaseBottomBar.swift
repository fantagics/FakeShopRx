//
//  PurchaseBottomBar.swift
//  FakeShop
//
//  Created by 이태형 on 2/22/25.
//

import UIKit

class PurchaseBottomBar: UIView {
    
    var delegate: PurchaseBottomBarDelegate?
    
    private let buyButton: UIButton = UIButton()
    private let cartButton: UIButton = UIButton()
    
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
extension PurchaseBottomBar{
    @objc func didTapButton(_ sender: UIButton){
        self.delegate?.showbottomSheet(type: sender == buyButton ? .buy : .cart)
    }
}

//MARK: - SETUP
extension PurchaseBottomBar{
    private func setup(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        self.backgroundColor = .primary
        self.layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        buyButton.setTitle(Purchase.buy.str.localized(), for: .normal)
        cartButton.setTitle(Purchase.cart.str.localized(), for: .normal)
        [buyButton, cartButton].forEach{
            $0.titleLabel?.font = .NanumGothic(type: .Bold, size: 20)
            $0.setTitleColor(.primary, for: .normal)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12
            $0.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
    }
    
    private func setUI(){
        let buttonStack: UIStackView = UIStackView(arrangedSubviews: [buyButton, cartButton])
        [buttonStack].forEach{
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fillEqually
            $0.spacing = 28
        }
        
        [buyButton, cartButton, buttonStack].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        self.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            buttonStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            buttonStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            buyButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalTo: buyButton.heightAnchor),
        ])
    }
}

protocol PurchaseBottomBarDelegate{
    func showbottomSheet(type: Purchase)
}
