//
//  CategoryTitleView.swift
//  FakeShop
//
//  Created by 이태형 on 3/1/25.
//

import UIKit

class CategoryTitleView: UIView {
    var delegate: CategoryTitleViewDelegate?
    
    private let titleLabel: UILabel = UILabel()
    
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
extension CategoryTitleView{
    func setTitle(category: String){
        titleLabel.text = category.localized() + " ▼"
    }
    @objc private func didTapTitle(_ sender: UITapGestureRecognizer){
        delegate?.didTapTitle()
    }
}

//MARK: - SETUP
extension CategoryTitleView{
    private func setViewConfig(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        self.backgroundColor = .primary
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTitle(_:))))
        
        titleLabel.textColor = .white
        titleLabel.font = .NanumGothic(type: .Bold, size: 18)
        titleLabel.textAlignment = .center
    }
    
    private func setUI(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }
}

protocol CategoryTitleViewDelegate{
    func didTapTitle()
}
