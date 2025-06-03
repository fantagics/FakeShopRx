//
//  LoginVM.swift
//  FakeShop
//
//  Created by 이태형 on 2024/08/07.
//

import UIKit
import RxSwift
import RxCocoa
import KakaoSDKUser
import KakaoSDKAuth
import RxKakaoSDKUser
import GoogleSignIn

class LoginViewModel{
    private let disposeBag = DisposeBag()
    private let req: AuthRequestRx = AuthRequestRx()
    
//MARK: LogIn - email
    func loginLogic(input: LoginInput) -> LoginOutput{
        let idValid: Observable<Bool> = input.idText.map{ $0.count >= 8 }
        let pwValid: Observable<Bool> = input.passwordText.map{ $0.count >= 8 }
        let termsValid: Observable<Bool> = input.agreementChecked
        
        let credentials = Observable.combineLatest(input.idText, input.passwordText){
            LoginInfomation(userName: $0, password: $1)
        }.share(replay: 1)
        
        let resultSubject = PublishSubject<Result<Void, LoginError>>()
        let loading = BehaviorRelay<Bool>(value: false)
        
        input.loginTap
            .withLatestFrom(Observable.combineLatest(credentials, idValid, pwValid, termsValid))
            .flatMapFirst { [weak self] (info, idValid, pwValid, termsValid) -> Observable<Result<Void, LoginError>> in
                guard let self = self, !loading.value else { return .empty() }
                
                if !termsValid { return .just(.failure(.notAgreed)) }
                if !idValid { return .just(.failure(.invalidId)) }
                if !pwValid { return .just(.failure(.invalidPw)) }
                
                loading.accept(true)
                
                return req.loginNative(id: info.userName, pw: info.password)
                    .map{ res in
                        self.setLoginInfo(.email, res.token)
                        return .success(())
                    }
                    .catch{ err in
                            .just(.failure(.anonymousError(err.localizedDescription)))
                    }
                    .do(onDispose: {
                        loading.accept(false)
                    })
            }
//            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: resultSubject)
            .disposed(by: disposeBag)
        
        return LoginOutput(
            loginResult: resultSubject,
            isLoading: loading.asObservable()
        )
    }
    
//MARK: LogIn - SNS
    let loginResult = PublishSubject<Result<Void, Error>>()
    
    func loginWithKakao(_ terms: Observable<Bool>?){
        guard let terms = terms else { return }
        
        terms
            .take(1)
            .subscribe(onNext: { [weak self] isAgreed in
                guard isAgreed else {
                    self?.loginResult.onNext(.failure(LoginError.notAgreed))
                    return
                }
                
                let loginObservable: Observable<OAuthToken> = UserApi.isKakaoTalkLoginAvailable() ?
                UserApi.shared.rx.loginWithKakaoTalk() : //카카오앱
                UserApi.shared.rx.loginWithKakaoAccount()  //웹로그인
                
                loginObservable
                    .subscribe(
                        onNext: { user in
                            self?.setLoginInfo(.kakao, user.accessToken)
                            self?.loginResult.onNext(.success(()))
                        },
                        onError: { err in
                            self?.loginResult.onNext(.failure(err))
                        }
                    )
                    .disposed(by: self?.disposeBag ?? DisposeBag())
            })
            .disposed(by: disposeBag)
    }
    
    func loginWithGoogle(_ terms: Observable<Bool>?, _ currentVC: UIViewController?){
        guard let terms = terms else { return }
        guard let currentVC = currentVC else{ return }
        
        terms
            .take(1)
            .subscribe(onNext: { [weak self] isAgreed in
                guard isAgreed else {
                    self?.loginResult.onNext(.failure(LoginError.notAgreed))
                    return
                }
                
                GIDSignIn.sharedInstance.signIn(withPresenting: currentVC) { signInResult, error in
                    if let err = error{
                        self?.logoutResult.onNext(.failure(err))
                        return
                    }
                    guard let token = signInResult?.user.idToken?.tokenString else {
                        self?.logoutResult.onNext(.failure(NSError(domain: "Google SignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token does not exist."])))
                        return
                    }
                    self?.setLoginInfo(.google, token)
                    self?.logoutResult.onNext(.success(()))
                }
            })
            .disposed(by: disposeBag)
    }
    
//MARK: LogOut
    let logoutResult = PublishSubject<Result<Void, Error>>()
    func logout(){
        switch Common.shared.loginType{
        case .google:
            GIDSignIn.sharedInstance.signOut()
            setLoginInfo(.none, nil)
            logoutResult.onNext(.success(()))
        case .kakao:
            UserApi.shared.rx.logout()
                .subscribe(onCompleted: { [weak self] in
                    self?.setLoginInfo(.none, nil)
                    self?.logoutResult.onNext(.success(()))
                }, onError: { [weak self] error in
                    self?.logoutResult.onNext(.failure(error))
                })
                .disposed(by: disposeBag)
        default:
            setLoginInfo(.none, nil)
            logoutResult.onNext(.success(()))
        }
    }
    
//MARK: etc
    struct LoginInfomation{
        let userName: String
        let password: String
    }
    
    func setLoginInfo(_ loginType: LoginType, _ token: String?){
        UserDefaults.standard.set(loginType.rawValue, forKey: "loginType")
        Common.shared.loginType = loginType
        UserDefaults.standard.set(token, forKey: "userToken")
        Common.shared.token = token ?? ""
    }
}
