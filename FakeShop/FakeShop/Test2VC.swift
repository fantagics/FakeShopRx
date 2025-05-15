//
//  Test2VC.swift
//  FakeShop
//
//  Created by 이태형 on 2024/12/02.
//

import UIKit

class Test2VC: UIViewController {
    
    private let myCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout{ (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            //Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Group (row)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: NSCollectionLayoutDimension.fractionalWidth(1/4))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            section.orthogonalScrollingBehavior = .continuous  //section내 스크롤 유형
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)),
                    elementKind: UICollectionView.elementKindSectionHeader, alignment: .top),
            ]
            
            return section
        }
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let arr: [String] = ["Apple", "Bug", "Create", "Delete", "Error"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewConfig()
    }
    
}

#Preview("Test2VC"){
    return Test2VC()
}

//MARK: - Function
extension Test2VC{
    
}

//MARK: - SETUP
extension Test2VC{
    private func setViewConfig(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        self.view.backgroundColor = .cyan
        
        [myCollectionView].forEach{
            $0.dataSource = self
            $0.delegate = self
            $0.register(CategoriesCollectionCell.self, forCellWithReuseIdentifier: CategoriesCollectionCell.identifier)
            $0.register(MyCollectionHeader.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyCollectionHeader.identifier)
            $0.backgroundColor = .white.withAlphaComponent(0)
            $0.reloadData()
        }
    }
    
    private func setUI(){
        [myCollectionView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            myCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            myCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            myCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}


extension Test2VC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CategoriesCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionCell.identifier, for: indexPath) as? CategoriesCollectionCell else{return UICollectionViewCell()}
        
        cell.titleLabel.text = arr[indexPath.item]
        
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyCollectionHeader.identifier, for: indexPath) as? MyCollectionHeader
        else{return UICollectionReusableView()}
        header.titleLabel.text = "TITLE"
        return header
    }
}

class MyCollectionHeader: UICollectionReusableView{
    static let identifier: String = String(describing: MyCollectionHeader.self)
    
    let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        [titleLabel].forEach{
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 20)
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
