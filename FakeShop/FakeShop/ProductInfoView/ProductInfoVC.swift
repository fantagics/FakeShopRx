//
//  ProductInfoVC.swift
//  FakeShop
//
//  Created by 이태형 on 2/20/25.
//

import UIKit
import Kingfisher

class ProductInfoVC: UIViewController {
    
    var product: Product?
    private let productInfoTable: UITableView = UITableView()
    private let bottomBar: PurchaseBottomBar = PurchaseBottomBar()
    private let dismissView: UIView = UIView()
    private var bottomSheet: PurchaseBottomSheet = PurchaseBottomSheet()
    private var bottomSheetTopAnchor: NSLayoutConstraint = NSLayoutConstraint()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewConfig()
    }
    
}

#Preview("ProductInfoVC"){
    let vc = ProductInfoVC()
    vc.product = Common.shared.dummyProduct
    return UINavigationController(rootViewController: vc)
}

//MARK: - Function
extension ProductInfoVC{
    @objc private func didTapGesture(_ sender: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.dismissView.backgroundColor = .black.withAlphaComponent(0)
            self.dismissView.isHidden = true
            self.bottomSheetTopAnchor.constant = 100
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

//MARK: - SETUP
extension ProductInfoVC{
    private func setViewConfig(){
        setNavigation()
        setAttribute()
        setUI()
    }
    
    private func setNavigation(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [
            .foregroundColor : UIColor.white,
            .font : UIFont.boldSystemFont(ofSize: 22)
        ]
        appearance.backgroundColor = .primary
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setAttribute(){
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        
        [productInfoTable].forEach{
            $0.backgroundColor = .white
            $0.dataSource = self
            $0.register(ProductImageTableCell.self, forCellReuseIdentifier: ProductImageTableCell.identifier)
            $0.register(ProductInfoTableCell.self, forCellReuseIdentifier: ProductInfoTableCell.identifier)
            $0.register(ProductDescTextTableCell.self, forCellReuseIdentifier: ProductDescTextTableCell.identifier)
            $0.separatorStyle = .none
            $0.bounces = false
        }
        
        [bottomBar].forEach{
            $0.delegate = self
        }
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapGesture(_:)))
        dismissView.addGestureRecognizer(tapGesture)
        dismissView.backgroundColor = .black.withAlphaComponent(0)
        dismissView.isHidden = true
        bottomSheetTopAnchor = bottomSheet.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 100) //-250
    }
    
    private func setUI(){
        let bottomUnsafeArea: UIView = UIView()
        bottomUnsafeArea.backgroundColor = .primary
        [bottomUnsafeArea, productInfoTable, bottomBar, dismissView, bottomSheet].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            productInfoTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productInfoTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productInfoTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productInfoTable.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),
            
            dismissView.topAnchor.constraint(equalTo: view.topAnchor),
            dismissView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dismissView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dismissView.bottomAnchor.constraint(equalTo: bottomSheet.topAnchor, constant: 32),
            
            bottomSheetTopAnchor,
            bottomSheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomUnsafeArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomUnsafeArea.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomUnsafeArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomUnsafeArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

//MARK: - DataSource & Delegate
extension ProductInfoVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard let cell: ProductImageTableCell = tableView.dequeueReusableCell(withIdentifier: ProductImageTableCell.identifier, for: indexPath) as? ProductImageTableCell else{return UITableViewCell()}
            
            guard let url = product?.image else{return cell}
            cell.image.kf.setImage(with: URL(string: url))
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.row == 1{
            guard let cell: ProductInfoTableCell = tableView.dequeueReusableCell(withIdentifier: ProductInfoTableCell.identifier, for: indexPath) as? ProductInfoTableCell else{return UITableViewCell()}
            
            cell.selectionStyle = .none
            guard let prod = product else{return cell}
            cell.category.text = prod.category.localized()
            cell.title.text = prod.title
            cell.setRatingStar(rate: prod.rating.rate)
            cell.ratingCount.text = "(\(prod.rating.count))"
            cell.price.text = prod.price.toCurrencyFormat()
            
            return cell
        } else{
            guard let cell: ProductDescTextTableCell = tableView.dequeueReusableCell(withIdentifier: ProductDescTextTableCell.identifier, for: indexPath) as? ProductDescTextTableCell else{return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.desc.text = product?.description ?? ""
            
            return cell
        }
    }
    
}

extension ProductInfoVC: PurchaseBottomBarDelegate{
    func showbottomSheet(type: Purchase) {
        self.bottomSheet.resetUI(product: self.product ?? Common.shared.dummyProduct, type: type)
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.dismissView.isHidden = false
            self.dismissView.backgroundColor = .black.withAlphaComponent(0.2)
            self.bottomSheetTopAnchor.constant = -250
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

