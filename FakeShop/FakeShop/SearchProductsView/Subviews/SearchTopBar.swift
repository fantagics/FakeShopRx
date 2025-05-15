//
//  SearchTopBar.swift
//  FakeShop
//
//  Created by 이태형 on 3/1/25.
//

import UIKit

class SearchTopBar: UIView {
    var delegate: SearchTopBarDelegate?
    
    private let searchField: UITextField = UITextField()
    private let searchButton: UIButton = UIButton()
    private let sortButton: UIButton = UIButton()
    
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
extension SearchTopBar{
    @objc func doneBtnClicked(_ sender: UIBarButtonItem){
        self.endEditing(true)
    }
    @objc func didTapButton(_ sender: UIButton){
        if sender == searchButton{
            delegate?.didTapSearchButton(searchText: searchField.text ?? "")
            self.endEditing(true)
        } else if sender == sortButton{
            delegate?.didTapSortButton()
        }
    }
}

//MARK: - SETUP
extension SearchTopBar{
    private func setViewConfig(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        self.backgroundColor = .primary
        
        [searchField].forEach{
            $0.addLeftPadding(16)
            $0.clearButtonMode = .always
            $0.font = .NanumGothic(type: .Bold, size: 18)
            $0.layer.cornerRadius = 16
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.darkGray.cgColor
            $0.backgroundColor = .white
            $0.textColor = .black
            $0.placeholder = "제품명을 입력해주세요."
            
            $0.returnKeyType = .done
            $0.delegate = self
        }
        
        [sortButton, searchButton].forEach{
            $0.backgroundColor = .white
            $0.tintColor = .primary
            $0.layer.cornerRadius = 20
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.darkGray.cgColor
            $0.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
        sortButton.setImage(UIImage(systemName: "line.3.horizontal.decrease", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)), for: .normal)
        searchButton.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
    }
    
    private func setUI(){
        [searchButton, sortButton, searchField].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            sortButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sortButton.heightAnchor.constraint(equalTo: sortButton.widthAnchor),
            sortButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            
            searchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchButton.heightAnchor.constraint(equalTo: sortButton.widthAnchor),
            searchButton.trailingAnchor.constraint(equalTo: sortButton.leadingAnchor, constant: -8),
            searchButton.widthAnchor.constraint(equalTo: sortButton.widthAnchor),
            
            searchField.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            searchField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            searchField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8),
            searchField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])
    }
}


extension SearchTopBar: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didTapSearchButton(searchText: searchField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
}

protocol SearchTopBarDelegate{
    func didTapSearchButton(searchText: String)
    func didTapSortButton()
}
