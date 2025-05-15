////
////  MainVC.swift
////  FakeShop
////
////  Created by 이태형 on 2024/07/27.
////
//
////pageControl을 배너 이미지 위에 올리고자 한다면
////i) Cell안에 CollectioView를  넣어주거나
////ii) NotificationCenter 혹은 RxSwift및Combine 필요
////https://applecider2020.tistory.com/42
////iii)복제된 VC는 Sandbox 옵션이 꺼져있는 상태임(ImageSliderShow사용)
//
//import UIKit
//
//class MainVC: UIViewController {
//    
//    private let vm: MainVM = MainVM()
//    
//    private lazy var footer: NoticeFooter = NoticeFooter()
//    private let mainCollectionView: UICollectionView = {
//        let layout = UICollectionViewCompositionalLayout{ (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//            //Item
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
////            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
//            
//            //Group (row)
//            let groupSize =
//            NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: sectionIndex == 0 ? NSCollectionLayoutDimension.fractionalWidth(1173/2080) : NSCollectionLayoutDimension.fractionalWidth(1/2))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: sectionIndex == 0 ? 1 : 4)
//            
//            //Section
//            let section = NSCollectionLayoutSection(group: group)
//            let sectionInset: CGFloat = sectionIndex == 0 ? 0 : 20
//            section.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
//            section.orthogonalScrollingBehavior = sectionIndex == 0 ? .paging : .continuous
//            
//            //Header or Footer 공간 확보
//            if sectionIndex != 0{
//                section.boundarySupplementaryItems = [
//                    NSCollectionLayoutBoundarySupplementaryItem(
//                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)),
//                        elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//                ]
//            }else{
//                section.boundarySupplementaryItems = [
//                    NSCollectionLayoutBoundarySupplementaryItem(
//                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)),
//                        elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
//                ]
//                section.visibleItemsInvalidationHandler = {(visibleItems, offset, env) in
//                    print(offset.x/env.container.contentSize.width)
//                }
//            }
//            return section
//        }
//        return UICollectionView(frame: .zero, collectionViewLayout: layout)
//    }()
//    
//    
//    //MARK: LC
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setup()
//    }
//    
//}
//
//#Preview("MainVC"){
//    return UINavigationController(rootViewController: MainVC())
//    
//}
//
////MARK: - Func
//extension MainVC{
////    @objc private func autoSlide(){
////        mainCollectionView.scrollToItem(at: IndexPath(item: <#T##Int#>, section: <#T##Int#>), at: <#T##UICollectionView.ScrollPosition#>, animated: <#T##Bool#>)
////    }
//}
//
////MARK: - inital_UI
//extension MainVC{
//    private func setup(){
//        setNavigation()
//        setAttribute()
//        setUI()
//    }
//    //Navigation
//    private func setNavigation(){
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .primary
//        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        
//        let logoImageView: UIImageView = UIImageView()
//        logoImageView.image = UIImage(named: "appBarLogo")
//        logoImageView.contentMode = .scaleAspectFit
//        self.navigationItem.titleView = logoImageView
//        logoImageView.translatesAutoresizingMaskIntoConstraints = false
//        logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 647 / 224).isActive = true
//        
//        let cartButton: UIBarButtonItem = UIBarButtonItem()
//        cartButton.image = UIImage(systemName: "cart")
//        self.navigationItem.rightBarButtonItem = cartButton
//        self.navigationItem.rightBarButtonItem?.tintColor = .white
//    }
//    //Attribute
//    private func setAttribute(){
//        self.view.backgroundColor = .white
//        
//        [mainCollectionView].forEach{
//            $0.dataSource = self
//            $0.delegate = self
//            $0.register(NoticeImageCell.self, forCellWithReuseIdentifier: NoticeImageCell.identifier)
//            $0.register(RecommendItemCell.self, forCellWithReuseIdentifier: RecommendItemCell.identifier)
//            $0.register(NoticeFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NoticeFooter.identifier)
//            $0.register(RecommendSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecommendSectionHeader.identifier)
//        }
//    }
//    //UI
//    private func setUI(){
//        [mainCollectionView].forEach{
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            mainCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//        ])
//    }
//}
//
//
////MARK: - DataSource&Delegate
//extension MainVC: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return section == 0 ? Common.shared.noticeArr.count : (3+1)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.section == 0 {
//            guard let cell: NoticeImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeImageCell.identifier, for: indexPath) as? NoticeImageCell else{return UICollectionViewCell()}
//            cell.imageView.image = Common.shared.noticeArr[indexPath.item]
//            return cell
//        } else {
//            guard let cell: RecommendItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendItemCell.identifier, for: indexPath) as? RecommendItemCell else{return UICollectionViewCell()}
//            return cell
//        }
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 5
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind{
//        case UICollectionView.elementKindSectionHeader:
//            guard indexPath.section > 0,
//                  let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommendSectionHeader.identifier, for: indexPath) as? RecommendSectionHeader
//            else{return UICollectionReusableView()}
//            header.titleLabel.text = "Title"
//            return header
//        case UICollectionView.elementKindSectionFooter:
////            guard indexPath.section == 0,
////                  let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NoticeFooter.identifier, for: indexPath) as? NoticeFooter
////            else{return UICollectionReusableView()}
//            guard indexPath.section == 0,
//                  let newfooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NoticeFooter.identifier, for: indexPath) as? NoticeFooter
//            else{return UICollectionReusableView()}
//            self.footer = newfooter
//            return footer
//        default:
//            return UICollectionReusableView()
//        }
//    }
//}
//
//extension MainVC: UICollectionViewDelegate{
//    
//}
