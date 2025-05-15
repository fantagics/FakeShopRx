//
//  MainVC.swift
//  FakeShop
//
//  Created by 이태형 on 2024/07/27.
//

import UIKit
import Kingfisher

class MainVC: UIViewController {
    
    private let vm: MainVM = MainVM()
    private var itemsOfCategory: [[Product]] = []
    
    private lazy var footer: NoticeFooter = NoticeFooter()
    private let mainCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout{ (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            //Item
            let itemSize = sectionIndex == 0 ?
                NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)) :
                NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            if sectionIndex != 0 {
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            }
            
            //Group (row)
            let groupSize =
            NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: sectionIndex == 0 ? NSCollectionLayoutDimension.fractionalWidth(1173/2080) : NSCollectionLayoutDimension.fractionalWidth(3/7))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = sectionIndex == 0 ?
                NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0) :
                NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12)
            section.orthogonalScrollingBehavior = sectionIndex == 0 ? .paging : .continuous
            
            //Header or Footer 공간 확보
            if sectionIndex != 0{
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(46)),
                        elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                ]
            }
            return section
        }
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    //MARK: LC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPreview(_:)), name: Notification.Name("reloadPreviewItems"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCategory(_:)), name: Notification.Name("receiveCategory"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
}

//#Preview("MainVC"){
//    return UINavigationController(rootViewController: MainVC())
//}
#Preview("MainTabBarController"){
    return MainTabBarController()
}

//MARK: - Func
extension MainVC{
    private func loadPreviewItems(){
        vm.getPreviewItems()
    }
    
    @objc private func reloadCategory(_ sender: Notification){
        loadPreviewItems()
    }
    @objc private func reloadPreview(_ sender: Notification){
        guard let info: [Product] = sender.userInfo?["pushData"] as? [Product] else{return}
        if !itemsOfCategory.flatMap({$0}).compactMap({$0}).map({$0.id}).contains(info[0].id){
            itemsOfCategory.append(info)
            mainCollectionView.reloadData()
        }
    }
    
    @objc private func didTapCartButton(_ sender: UIBarButtonItem){
        print("Cart Page")
    }
}

//MARK: - inital_UI
extension MainVC{
    private func setup(){
        setNavigation()
        setAttribute()
        setUI()
    }
    //Navigation
    private func setNavigation(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .primary
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let logoImageView: UIImageView = UIImageView()
        logoImageView.image = UIImage(named: "appBarLogo")
        logoImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logoImageView
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 647 / 224).isActive = true
        
        let cartButton: UIBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "cart"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(didTapCartButton(_:))
        )
        self.navigationItem.rightBarButtonItem = cartButton
        self.navigationItem.rightBarButtonItem?.tintColor = .white
    }
    //Attribute
    private func setAttribute(){
        self.view.backgroundColor = .white
        
        [mainCollectionView].forEach{
            $0.backgroundColor = .white
            $0.dataSource = self
            $0.delegate = self
            $0.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
            $0.register(RecommendItemCell.self, forCellWithReuseIdentifier: RecommendItemCell.identifier)
            $0.register(RecommendSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecommendSectionHeader.identifier)
        }
    }
    //UI
    private func setUI(){
        [mainCollectionView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}


//MARK: - DataSource&Delegate
extension MainVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : itemsOfCategory[section - 1].count + 1
//        return section == 0 ? 1 : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell: BannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else{return UICollectionViewCell()}
            return cell
        } else {
            guard let cell: RecommendItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendItemCell.identifier, for: indexPath) as? RecommendItemCell else{return UICollectionViewCell()}
            if indexPath.item == 3 {
                cell.imageView.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
                cell.imageView.contentMode = .center
                cell.imageView.tintColor = .black
                cell.titleLabel.text = "more".localized()
                cell.priceLabel.text = ""
                cell.ratingLabel.text = ""
            } else {
                let product: Product = itemsOfCategory[indexPath.section - 1][indexPath.item]
                cell.imageView.kf.setImage(with: URL(string: product.image))
                cell.imageView.contentMode = .scaleToFill
                cell.titleLabel.text = product.title
                cell.priceLabel.text = product.price.toCurrencyFormat()
                cell.ratingLabel.text = "⭐️ \(product.rating.rate) / 🛒 \(product.rating.count)"
            }
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemsOfCategory.count + 1
//        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              indexPath.section > 0,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommendSectionHeader.identifier, for: indexPath) as? RecommendSectionHeader
        else{return UICollectionReusableView()}
        header.titleLabel.text = itemsOfCategory[indexPath.section - 1][0].category.localized()
//        header.titleLabel.text = String(format: NSLocalizedString(itemsOfCategory[indexPath.section - 1][0].category, comment: ""))
        return header
    }
}

extension MainVC: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            if indexPath.item == 3{
                let nextvc: SearchProductsVC = SearchProductsVC()
                nextvc.category = itemsOfCategory[indexPath.section - 1][0].category
                let nextnvc: UINavigationController = UINavigationController(rootViewController: nextvc)
                nextnvc.modalPresentationStyle = .fullScreen
                self.present(nextnvc, animated: false)
            } else {
                let nextVC: ProductInfoVC = ProductInfoVC()
                nextVC.product = itemsOfCategory[indexPath.section - 1][indexPath.item]
                self.navigationItem.backButtonDisplayMode = .minimal
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}
