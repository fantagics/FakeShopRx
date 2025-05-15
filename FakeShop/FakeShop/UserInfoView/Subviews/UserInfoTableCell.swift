//
//  UserInfoTableCell.swift
//  FakeShop
//
//  Created by 이태형 on 2/18/25.
//

import UIKit

class UserInfoTableCell: UITableViewCell {
    static let identifier: String = String(describing: UserInfoTableCell.self)
    
    let contentsView: UIView = UIView()
    let profileView: UIImageView = UIImageView()
    let userNameLabel: UILabel = UILabel()
    let emailLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview("UserInfoVC"){
    return UINavigationController(rootViewController: UserInfoVC())
    
}


//MARK: - SETUP
extension UserInfoTableCell{
    private func setup(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        self.layer.cornerRadius = 20
        self.backgroundColor = .gray
        
        [contentsView].forEach{
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .subColor
            $0.clipsToBounds = true
        }
        
        [profileView].forEach{
            $0.image = UIImage(systemName: "person.fill",  withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            $0.contentMode = .center
            $0.backgroundColor = .gray
            $0.tintColor = .white
            $0.layer.cornerRadius = 38
        }
        
        [userNameLabel].forEach{
            $0.font = UIFont.NanumGothic(type: .Bold, size: 22)
            $0.text = "USERNAME"
            $0.textColor = .darkGray
        }
        
        [emailLabel].forEach{
            $0.font = UIFont.NanumGothic(type: .Regular, size: 14)
            $0.text = "USER@APPLE.COM"
            $0.textColor = .darkGray
        }
        
    }
    
    private func setUI(){
        let labelStack: UIStackView = UIStackView(arrangedSubviews: [userNameLabel, emailLabel])
        [labelStack].forEach{
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .fill
            $0.spacing = 10
        }
        
        [contentsView, profileView, labelStack].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            contentsView.topAnchor.constraint(equalTo: self.topAnchor),
            contentsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentsView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            
            profileView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16),
            profileView.widthAnchor.constraint(equalTo: profileView.heightAnchor),
            profileView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileView.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16),
            profileView.widthAnchor.constraint(equalToConstant: 80),
            
            labelStack.centerYAnchor.constraint(equalTo: contentsView.centerYAnchor),
            labelStack.leadingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: 16),
            labelStack.trailingAnchor.constraint(lessThanOrEqualTo: contentsView.trailingAnchor, constant: -16),
            labelStack.topAnchor.constraint(greaterThanOrEqualTo: contentsView.topAnchor, constant: 16),
        ])
    }
}
