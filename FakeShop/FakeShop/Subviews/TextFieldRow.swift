//
//  TextFieldRow.swift
//  FakeShop
//
//  Created by 이태형 on 12/26/24.
//

import UIKit

class TextFieldRow: UIView{
    private var fieldType: TextFieldType
    private var textField: UITextField
    private var guideLabel: UILabel
    
    private let titleLabel: UILabel = UILabel()
    private let textFieldRightView: UIView = UIView()
    private let invisableButton: UIButton = UIButton()
    
    required init(_ fieldType: TextFieldType, _ textField: UITextField, _ guideLabel: UILabel){
        self.fieldType = fieldType
        self.textField = textField
        self.guideLabel = guideLabel
        super.init(frame: .zero)
        setViewConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Func
extension TextFieldRow{
    @objc func didTapInvisableButton(_ sender: UIButton){
        textField.isSecureTextEntry.toggle()
    }
}

//MARK: - SetUI
extension TextFieldRow{
    private func setViewConfig(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        [titleLabel].forEach{
            $0.text = fieldType.title
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 16)
        }
        
        [guideLabel].forEach{
            $0.text = ""
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = .orange
        }
        
        [textField].forEach{
            $0.placeholder = fieldType.placeholder
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.primary.cgColor
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .black
            $0.addLeftPadding()
        }
        
        if fieldType == .password || fieldType == .confirmPassword{
            [invisableButton].forEach{
                $0.setImage(UIImage(systemName: "eye", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14)), for: .normal)
                $0.tintColor = .gray
                $0.addTarget(self, action: #selector(didTapInvisableButton(_:)), for: .touchUpInside)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            textFieldRightView.translatesAutoresizingMaskIntoConstraints = false
            textFieldRightView.addSubview(invisableButton)
            invisableButton.topAnchor.constraint(greaterThanOrEqualTo: textFieldRightView.topAnchor).isActive = true
            invisableButton.bottomAnchor.constraint(greaterThanOrEqualTo: textFieldRightView.bottomAnchor).isActive = true
            invisableButton.centerYAnchor.constraint(equalTo: textFieldRightView.centerYAnchor).isActive = true
            invisableButton.leadingAnchor.constraint(equalTo: textFieldRightView.leadingAnchor).isActive = true
            invisableButton.trailingAnchor.constraint(equalTo: textFieldRightView.trailingAnchor, constant: -10).isActive = true
            textField.rightView = textFieldRightView
            textField.rightViewMode = .always
        }
    }
    
    private func setUI(){
        [titleLabel, textField, guideLabel].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let guideLabelCenterYConstraint: NSLayoutConstraint = guideLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        guideLabelCenterYConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            guideLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 15),
            guideLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            guideLabelCenterYConstraint,
            guideLabel.bottomAnchor.constraint(lessThanOrEqualTo: textField.topAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            textField.heightAnchor.constraint(equalToConstant: 48),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
        ])
    }
}
