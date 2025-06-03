//
//  UserInfoVC.swift
//  FakeShop
//
//  Created by 이태형 on 1/22/25.
//

import UIKit
import RxSwift
import RxCocoa

class UserInfoVC: UIViewController {
    private let viewModel: UserInfoViewModel = UserInfoViewModel()
    private let loginViewModel: LoginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    private var settingMenus: [SettingMenu] = []
    
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

//MARK: - BindViewModel
extension UserInfoVC{
    private func bindViewModel(){
        let input = UserInfoViewModel.Input(
            selectedRow: userInfoTableView.rx.itemSelected.asObservable()
        )
        let output = viewModel.tableViewLogic(input: input)
        
        output.settingMenus
            .drive(userInfoTableView.rx.items){ tableView, row, item in
                if row == 0{
                    guard let cell: UserInfoTableCell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableCell.identifier) as? UserInfoTableCell else{return UITableViewCell()}
                    cell.accessoryType = .disclosureIndicator
                    cell.selectionStyle = .none
                    return cell
                } else {
                    guard let cell: SettingMenuTableCell = tableView.dequeueReusableCell(withIdentifier: SettingMenuTableCell.identifier) as? SettingMenuTableCell else{return UITableViewCell()}
                    cell.accessoryType = .none
                    cell.selectionStyle = .none
                    cell.iconView.image = UIImage(systemName: item.icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))
                    cell.titleLabel.text = item.str.localized()
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        output.didTapUserInfo
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                print("did Tap UserInfoView")
            })
            .disposed(by: disposeBag)
        
        output.didTapMenu
            .drive(onNext: {[weak self] item in
                guard let self = self else { return }
                if item == .logout{
                    let logoutAlert: UIAlertController = UIAlertController.cancelableMessageAlert(
                        title: "logout".localized(),
                        message: "Would you like to sign out?".localized(),
                        completion: {
                            self.loginViewModel.logout()
                        })
                    self.present(logoutAlert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        loginViewModel.logoutResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] res in
                switch res{
                case .success:
                    let nextvc = LoginVC()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(nextvc, animated: false)
                case .failure(let err):
                    self?.present(UIAlertController.messageAlert(title: nil, message: err.localizedDescription, completion: nil), animated: true)
                    
                }
            })
            .disposed(by: disposeBag)
        
//        userInfoTableView.rx.itemSelected
//            .bind(to: Binder(self) { owner, indexPath in
//                owner.userInfoTableView.deselectRow(at: indexPath, animated: true)
//            })
//            .disposed(by: disposeBag)
    }
}

//MARK: - inital_UI
extension UserInfoVC{
    private func setup(){
        setNavigation()
        setAttribute()
        setUI()
        bindViewModel()
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
            $0.bounces = false
            $0.separatorStyle = .none
            $0.register(SettingMenuTableCell.self, forCellReuseIdentifier: SettingMenuTableCell.identifier)
            $0.register(UserInfoTableCell.self, forCellReuseIdentifier: UserInfoTableCell.identifier)
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
