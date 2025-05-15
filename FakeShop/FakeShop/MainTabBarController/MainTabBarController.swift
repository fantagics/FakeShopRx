//
//  MainTabBarController.swift
//  FakeShop
//
//  Created by 이태형 on 1/22/25.
//

import UIKit

class MainTabBarController: UITabBarController{
    
    private let sideWidth: CGFloat = 200
    private var isSideMenuVisable = false
    private let sideMenuBackView: UIView = UIView()
    private var sideMenuLeading: NSLayoutConstraint = NSLayoutConstraint()
    private let sideMenu: SideMenuView = SideMenuView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSideMenu()
        setTabBarController()
        self.delegate = self
    }
    
}

#Preview("MainTabBarController"){
    return MainTabBarController()
}

//MARK: - FUNC(for SideMenu)
extension MainTabBarController{
    private func toggleSideMenu(){
        func activity(){
            sideMenuLeading.constant = isSideMenuVisable ? -sideWidth : 0
            sideMenuBackView.isHidden = isSideMenuVisable
            sideMenuBackView.alpha = isSideMenuVisable ? 0 : 0.8
            isSideMenuVisable.toggle()
        }
        //animation
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            activity()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer){
        let translationX: CGFloat = sender.translation(in: sender.view).x
        
        switch sender.state {
        case .began:
            print("PanGesture Began")
        case .changed:
            if -translationX <= sideWidth && -translationX > -1{
                self.sideMenuLeading.constant = translationX
                self.sideMenuBackView.alpha = (200+translationX) / 250
            }
        case .ended:
            if -translationX > (sideWidth/2) {
                self.sideMenuLeading.constant = -sideWidth
                self.sideMenuBackView.isHidden = true
                isSideMenuVisable = false
            }
            else{
                self.sideMenuLeading.constant = 0
                self.sideMenuBackView.alpha = 0.8
            }
        default:
            break
        }
    }
    
    @objc func tapBackView(_ sender: UITapGestureRecognizer){
        func activity(){
            self.sideMenuLeading.constant = -sideWidth
            self.sideMenuBackView.isHidden = true
            isSideMenuVisable = false
        }
        //animation
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            activity()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

//MARK: - SETUI
extension MainTabBarController{
    private func setTabBarController(){
        let mainVC = UINavigationController(rootViewController: MainVC())
        let userInfoVC = UINavigationController(rootViewController: UserInfoVC())
        self.viewControllers = [UIViewController(), mainVC, userInfoVC]
        if let items = self.tabBar.items{
            items[0].image = UIImage(systemName: "line.3.horizontal")?.withBaselineOffset(fromBottom: UIFont.systemFontSize * 3 / 4)
            items[0].tag = 0
            items[1].image = UIImage(systemName: "house.fill")?.withBaselineOffset(fromBottom: UIFont.systemFontSize)
            items[1].tag = 1
            items[2].image = UIImage(systemName: "person.fill")?.withBaselineOffset(fromBottom: UIFont.systemFontSize)
            items[2].tag = 2
        }
        
        self.selectedIndex = 1
        self.tabBar.backgroundColor = .primary
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .lightGray
        self.tabBar.layer.cornerRadius = 16
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if #available(iOS 15.0, *){
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .primary
            self.tabBar.standardAppearance = tabBarAppearance
            self.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    private func setSideMenu(){
        [sideMenu].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 20
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            $0.delegate = self
        }
        [sideMenuBackView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isHidden = true
            $0.backgroundColor = .black
            $0.alpha = 0
            $0.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackView(_:))))
        }
        sideMenuLeading = sideMenu.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -sideWidth)
        
        //SideMenu Init
        self.view.addSubview(sideMenuBackView)
        self.view.addSubview(sideMenu)
        NSLayoutConstraint.activate([
            sideMenuBackView.topAnchor.constraint(equalTo: self.view.topAnchor),
            sideMenuBackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            sideMenuBackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            sideMenuBackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            sideMenu.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 36),
            sideMenu.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -self.tabBar.frame.height),
            sideMenu.widthAnchor.constraint(equalToConstant: sideWidth),
            sideMenuLeading,
        ])
    }
}

//MARK: - Delegate
extension MainTabBarController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard viewController.tabBarItem.tag != 0 else{
            toggleSideMenu()
            return false
        }
        return true
    }
}

extension MainTabBarController: SideMenuViewDelegate{
    func presentNextVC(category: String) {
        let nextvc: SearchProductsVC = SearchProductsVC()
        nextvc.category = category
        let nextnvc: UINavigationController = UINavigationController(rootViewController: nextvc)
        nextnvc.modalPresentationStyle = .fullScreen
        self.present(nextnvc, animated: false)
    }
}
