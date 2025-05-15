//
//  UserInfoVC.swift
//  FakeShop
//
//  Created by 이태형 on 1/22/25.
//

import UIKit

class UserInfoVC: UIViewController {
    private let vm: LoginVM = LoginVM()
    
    private let userInfoTableView: UITableView = UITableView()
    
    //MARK: LC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
}
#Preview("UserInfoVC"){
    return UINavigationController(rootViewController: UserInfoVC())
    
}

//MARK: - Func
extension UserInfoVC{
    
}

//MARK: - inital_UI
extension UserInfoVC{
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
        
        let cartButton: UIBarButtonItem = UIBarButtonItem()
        cartButton.image = UIImage(systemName: "cart")
        self.navigationItem.rightBarButtonItem = cartButton
        self.navigationItem.rightBarButtonItem?.tintColor = .white
    }
    //Attribute
    private func setAttribute(){
        self.view.backgroundColor = .white
        
        [userInfoTableView].forEach{
            $0.backgroundColor = .white
            $0.dataSource = self
            $0.delegate = self
            $0.register(SettingMenuTableCell.self, forCellReuseIdentifier: SettingMenuTableCell.identifier)
            $0.register(UserInfoTableCell.self, forCellReuseIdentifier: UserInfoTableCell.identifier)
            $0.bounces = false
            $0.separatorStyle = .none
        }
    }
    //UI
    private func setUI(){
        userInfoTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userInfoTableView)
        
        NSLayoutConstraint.activate([
            userInfoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userInfoTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            userInfoTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            userInfoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

//MARK: - DataSource & Delegate
extension UserInfoVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell: UserInfoTableCell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableCell.identifier, for: indexPath) as? UserInfoTableCell else{return UITableViewCell()}
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
        } else{
            guard let cell: SettingMenuTableCell = tableView.dequeueReusableCell(withIdentifier: SettingMenuTableCell.identifier, for: indexPath) as? SettingMenuTableCell else{return UITableViewCell()}
            cell.accessoryType = .none
            cell.selectionStyle = .none
            if let img = SettingMenu(rawValue: indexPath.row - 1)?.icon{
                cell.iconView.image = UIImage(systemName: img, withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))
            }
            if let title = SettingMenu(rawValue: indexPath.row - 1)?.str{
                cell.titleLabel.text = title.localized()
            }
            return cell
        }
    }
    
}
extension UserInfoVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        if indexPath.row > 0, SettingMenu(rawValue: indexPath.row - 1) == .logout {
            let logoutAlert: UIAlertController = UIAlertController.cancelableMessageAlert(title: "logout".localized(), message: "Would you like to sign out?".localized(), completion: {
                self.vm.logout()
                let nextvc = LoginVC()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(nextvc, animated: false)
            })
            self.present(logoutAlert, animated: true)
        }
    }
}

extension UserInfoVC{
    enum SettingMenu: Int, CaseIterable{
        case orderHistory
        case cart
        case inquiryHistory
        case logout
        
        var str: String{
            switch self{
                case .orderHistory: "orderHistory"
                case .cart: "cart"
                case .inquiryHistory: "inquiryHistory"
                case .logout: "logout"
            }
        }
        
        var icon: String{
            switch self{
            case .orderHistory: "list.bullet"
                case .cart: "cart"
                case .inquiryHistory: "info.circle"
                case .logout: "rectangle.portrait.and.arrow.right"
            }
        }
    }
}
