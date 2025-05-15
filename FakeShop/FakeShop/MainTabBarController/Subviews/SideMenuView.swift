//
//  SideMenuView.swift
//  FakeShop
//
//  Created by 이태형 on 1/31/25.
//

import UIKit

class SideMenuView: UIView{
    var delegate: SideMenuViewDelegate?
    private let vm: MainVM = MainVM()
    
    private let titleLabel: UILabel = UILabel()
    private let categoryCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = CGSize(width: 176, height: 50)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCategory(_:)), name: Notification.Name("receiveCategory"), object: nil)
        setup()
        vm.getCategories()
//        reloadCategories()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}

#Preview("MainTabBarController"){
    return MainTabBarController()
}

//MARK: - Func
extension SideMenuView{
//    private func reloadCategories(){
//        vm.getCategories(){ res in
//            switch res{
//            case .success(_):
//                self.categoryCollectionView.reloadData()
//            case .failure(let err):
//                print(err)
//            }
//        }
//    }
    
    @objc private func reloadCategory(_ sender: Notification){
        categoryCollectionView.reloadData()
    }
}

//MARK: - inital_UI
extension SideMenuView{
    private func setup(){
        setAttribute()
        setUI()
    }
    //Attribute
    private func setAttribute(){
        self.backgroundColor = .primary
        
        [titleLabel].forEach{
            $0.text = "Category".localized()
            $0.textColor = .white
            $0.font = .NanumGothic(type: .ExtraBold, size: 20)
        }
        
        
        [categoryCollectionView].forEach{
            $0.dataSource = self
            $0.delegate = self
            $0.register(CategoriesCollectionCell.self, forCellWithReuseIdentifier: CategoriesCollectionCell.identifier)
            $0.backgroundColor = .white.withAlphaComponent(0)
            $0.reloadData()
        }
    }
    //UI
    private func setUI(){
        [titleLabel, categoryCollectionView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 10),
            
            categoryCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            categoryCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            categoryCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            categoryCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -60),
        ])
    }
}


//MARK: - DataSource & Delegate & Layout
extension SideMenuView: UICollectionViewDataSource{
    //DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Common.shared.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CategoriesCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionCell.identifier, for: indexPath) as? CategoriesCollectionCell else{return UICollectionViewCell()}
        
        cell.titleLabel.text = Common.shared.categories[indexPath.item].localized()
        
        return cell
    }
}
extension SideMenuView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.presentNextVC(category: Common.shared.categories[indexPath.item])
    }
}

protocol SideMenuViewDelegate{
    func presentNextVC(category: String)
}
