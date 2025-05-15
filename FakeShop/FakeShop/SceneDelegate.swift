//
//  SceneDelegate.swift
//  FakeShop
//
//  Created by 이태형 on 2024/07/18.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let loginVc = LoginVC()
        let mainVc = MainTabBarController()
        if let token: String = UserDefaults.standard.string(forKey: "userToken"){
            Common.shared.token = token
            let loginTypeStr: String = UserDefaults.standard.string(forKey: "loginType") ?? LoginType.none.rawValue
            Common.shared.loginType = LoginType(rawValue: loginTypeStr) ?? .none
        }
        window?.rootViewController = (Common.shared.token.count > 0) ? mainVc : UINavigationController(rootViewController: loginVc)
        
//        window?.rootViewController = mainVc
        
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }
    
    func changeRootView(_ vc: UIViewController, animated: Bool){
        guard let window = self.window else{return}
        window.rootViewController = vc
        
        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve] ,animations: nil, completion: nil)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            //google
            if (GIDSignIn.sharedInstance.handle(url)) {
                _ =  GIDSignIn.sharedInstance.handle(url)
            }
            //kakao
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
}

