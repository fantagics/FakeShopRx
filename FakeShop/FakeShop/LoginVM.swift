//
//  LoginVM.swift
//  FakeShop
//
//  Created by 이태형 on 2024/08/07.
//

import UIKit
import KakaoSDKUser
import GoogleSignIn

class LoginVM {
    var isAgreeTerms: Bool = false
    
    func loginValid(loginType: LoginType, idTextField: UITextField = UITextField(), pwTextField: UITextField = UITextField(), currentVC: UIViewController = UIViewController(), completion: @escaping (Result<String?,LoginError>) -> Void){
        guard isAgreeTerms else{
            completion(.failure(.rejectAgreement))
            return
        }
        guard NetworkMonitor.shared.isConnected else{
            completion(.failure(.unConected))
            return
        }
        switch loginType{
        case .email:
            guard let idText = idTextField.text, !idText.isEmpty else{
                completion(.failure(.idEmpty))
                return
            }
            guard let pwText = pwTextField.text, !pwText.isEmpty else{
                completion(.failure(.pwEmpty))
                return
            }
            AuthRequest.logIn(idText, pwText){ res in
                switch res{
                case .success(let data): //token
                    self.setLoginInfo(.email, data.token)
                    completion(.success(data.token))
                case .failure(let err):
                    completion(.failure(.fail))
                }
            }
        case .google:
            GIDSignIn.sharedInstance.signIn(withPresenting: currentVC) { signInResult, error in
                guard error == nil else { return }
                guard let token = signInResult?.user.idToken?.tokenString else { return }
                self.setLoginInfo(.google, token)
                completion(.success(token))
            }
        case .kakao:
            // 카카오톡 실행 가능 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }else {
                        print("loginWithKakaoTalk() success.")
                        self.setLoginInfo(.kakao, oauthToken?.accessToken)
                        completion(.success(oauthToken?.accessToken))
                    }
                }
            }else{  //웹브라우저에서 카카오톡 계정으로 로그인
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }else {
                        print("loginWithKakaoAccount() success.")
                        self.setLoginInfo(.kakao, oauthToken?.accessToken)
                        completion(.success(oauthToken?.accessToken))
                    }
                }
            }
        default:
            completion(.failure(.fail))
            return
        }
    }
    
    func setLoginInfo(_ loginType: LoginType, _ token: String?){
        UserDefaults.standard.set(loginType.rawValue, forKey: "loginType")
        Common.shared.loginType = loginType
        UserDefaults.standard.set(token, forKey: "userToken")
        Common.shared.token = token ?? ""
    }
    
    func logout(){
        setLoginInfo(.none, nil)
        switch Common.shared.loginType{
        case .google:
            GIDSignIn.sharedInstance.signOut()
        case .kakao:
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("logout() success.")
                }
            }
        default:
            return
        }
    }
}
