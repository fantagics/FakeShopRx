//
//  SettingMenuTableCell.swift
//  FakeShop
//
//  Created by 이태형 on 2/18/25.
//

import UIKit

class SettingMenuTableCell: UITableViewCell {
    static let identifier: String = String(describing: SettingMenuTableCell.self)
    
    let contentsView: UIView = UIView()
    let shadowView: UIView = UIView()
    let iconView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    
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
extension SettingMenuTableCell{
    private func setup(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        self.backgroundColor = .white
        [shadowView].forEach{
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .gray
        }
        [contentsView].forEach{
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .subColor
            $0.clipsToBounds = true
        }
        [iconView].forEach{
            $0.image = UIImage(systemName: "photo.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            $0.contentMode = .center
            $0.tintColor = .gray
            $0.layer.cornerRadius = 14
        }
        [titleLabel].forEach{
            $0.text = "유저메뉴"
            $0.font = UIFont.NanumGothic(type: .Bold, size: 20)
            $0.textColor = .darkGray
        }
    }
    
    private func setUI(){
        [shadowView, contentsView, iconView, titleLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11.5),
            shadowView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentsView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            contentsView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            contentsView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            contentsView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            
            iconView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 20),
            iconView.centerYAnchor.constraint(equalTo: contentsView.centerYAnchor),
            iconView.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentsView.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentsView.trailingAnchor, constant: -16),
        ])
    }
}
