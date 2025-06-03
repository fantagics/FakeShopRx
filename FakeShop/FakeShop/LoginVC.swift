//
//  LoginVC.swift
//  FakeShop
//
//  Created by 이태형 on 2024/07/27.
//

import UIKit
//import SwiftUI
import RxSwift
import RxCocoa
import SafariServices

class LoginVC: UIViewController {
    private let viewModel: LoginViewModel = LoginViewModel()
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let agreementChecked = BehaviorRelay<Bool>(value: false)
    
    private let introView: UIView = UIView()
    private let loginPannel: UIView = UIView()
    private let welcomeLabel: UILabel = UILabel()
    private let descLabel: UILabel = UILabel()
    private let usernameField: UITextField = UITextField()
    private let passwordField: UITextField = UITextField()
    private let agreeButton: UIButton = UIButton()
    private let termsLabel: UILabel = UILabel()
    private let loginButton: UIButton = UIButton()
    private let signupButton: UIButton = UIButton()
    private let googleButton: UIButton = UIButton()
    private let kakaoButton: UIButton = UIButton()
    private let appleButton: UIButton = UIButton()
    private let loadingView: UIView = UIView()
    private let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private let emptyViewGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    private let termsGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

#Preview("LoginView"){
    return UINavigationController(rootViewController: LoginVC())
}

//MARK: - BindVM
extension LoginVC{
    private func bindViewModel(){
        emptyViewGesture.rx.event
            .bind{ [weak self] _ in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        signupButton.rx.tap
            .subscribe(onNext: {
//                let nextVC = UIHostingController(rootView: SignUpSV())
                let nextVC = SignUpVC()
                self.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        termsGesture.rx.event
            .bind{ [weak self] sender in
                guard let self = self else{ return }
                let point = sender.location(in: termsLabel)
                if let serviceRect = termsLabel.boundingRectForCharacterRange(subText: "Terms of Service".localized()),
                   serviceRect.contains(point){
                    present(SFSafariViewController(url: URL.serviceTermsUrl), animated: true)
                }
                if let serviceRect = termsLabel.boundingRectForCharacterRange(subText: "Privacy Policy".localized()),
                   serviceRect.contains(point){
                    present(SFSafariViewController(url: URL.privateTermsUrl), animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        agreeButton.rx.tap
            .withLatestFrom(agreementChecked)
            .map{ !$0 }
            .bind(to: agreementChecked)
            .disposed(by: disposeBag)
        
        agreementChecked
            .map{ UIImage(systemName: $0 ? "checkmark.square" : "square") }
            .bind(to: agreeButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        let input: LoginInput = LoginInput(
            idText: usernameField.rx.text.orEmpty.asObservable(),
            passwordText: passwordField.rx.text.orEmpty.asObservable(),
            agreementChecked: agreementChecked.distinctUntilChanged().share(replay: 1),
            loginTap: loginButton.rx.tap.asObservable())
        let output: LoginOutput = viewModel.loginLogic(input: input)
        
        output.loginResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] res in
                guard let self = self else{return}
                
                switch res {
                case .success:
                    let nextvc = MainTabBarController()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(nextvc, animated: false)
                case .failure(let err):
                    print("email Login Fail")
                    self.present(UIAlertController.messageAlert(title: nil, message: err.validMessage, completion: nil), animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.isLoading.map{!$0}
            .observe(on: MainScheduler.instance)
            .bind(to: loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        output.isLoading
            .observe(on: MainScheduler.instance)
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        kakaoButton.rx.tap
            .bind{ [weak self] in
                self?.viewModel.loginWithKakao(self?.agreementChecked.distinctUntilChanged().share(replay: 1))
            }
            .disposed(by: disposeBag)
        
        googleButton.rx.tap
            .bind{ [weak self] in
                self?.viewModel.loginWithGoogle(self?.agreementChecked.distinctUntilChanged().share(replay: 1), self)
            }
            .disposed(by: disposeBag)
        
        viewModel.loginResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] res in
                switch res{
                case .success:
                    let nextvc = MainTabBarController()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(nextvc, animated: false)
                case .failure(let err):
                    if let error = err as? LoginError{
                        self?.present(UIAlertController.messageAlert(title: nil, message: error.validMessage, completion: nil), animated: true)
                    } else {
                        print("SNS Login Error:", err.localizedDescription)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - inital_UI
extension LoginVC{
    private func setup(){
        setNavigation()
        setAttribute()
        setUI()
        bindViewModel()
    }
    //NavigationController
    private func setNavigation(){
        self.navigationItem.backButtonDisplayMode = .minimal
    }
    //Attribute
    private func setAttribute(){
        view.backgroundColor = .white
        view.addGestureRecognizer(emptyViewGesture)
        
        [welcomeLabel].forEach{
            $0.text = "Wellcome!".localized()
            $0.textColor = .black
            $0.textAlignment = .left
            $0.font = .boldSystemFont(ofSize: 40)
        }
        [descLabel].forEach{
            $0.numberOfLines = 0
            $0.textAlignment = .left
//            $0.font = .systemFont(ofSize: 16)
            let appName = "FakeShop".localized()
            let usedApiName = "fakestoreapi"
            let loginableData = "(mor_2314/83r5^_)"
            let guideText = "'%@' is a fake shopping app that uses '%@'. %@".localized(a: appName, b: usedApiName, c: loginableData)
            let generalAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.black.cgColor
            ]
            let accentAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor: UIColor.black.cgColor
            ]
            let blurAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.gray.cgColor
            ]
            let mutableString: NSMutableAttributedString = NSMutableAttributedString()
            mutableString.append(NSAttributedString(string: guideText, attributes: generalAttributes))
            mutableString.setAttributes(accentAttributes, range: (guideText as NSString).range(of: appName))
            mutableString.setAttributes(accentAttributes, range: (guideText as NSString).range(of: usedApiName))
            mutableString.setAttributes(blurAttributes, range: (guideText as NSString).range(of: loginableData))
            $0.attributedText = mutableString
            $0.sizeToFit()
        }
        
        [usernameField, passwordField].forEach{
            $0.addLeftPadding(20)
            if let clearButton = $0.value(forKeyPath: "_clearButton") as? UIButton{
                clearButton.setImage(UIImage(systemName: "x.circle"), for: .normal)
                clearButton.tintColor = .primaryColor
            }
            $0.clearButtonMode = .always
            $0.font = .systemFont(ofSize: 16)
            $0.layer.cornerRadius = 25
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.primaryColor?.cgColor
        }
        usernameField.placeholder = "user name"
        passwordField.placeholder = "password"
        passwordField.isSecureTextEntry = true
        
        [agreeButton].forEach{
            $0.setImage(UIImage(systemName: "square"), for: .normal)
            $0.tintColor = .primaryColor
        }
        
        [termsLabel].forEach{
            $0.numberOfLines = 0
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(termsGesture)
            
            let privateTerm = "Privacy Policy".localized()
            let serviceTerm = "Terms of Service".localized()
            let guideText = "I accept the %@ and the %@.".localized(a: privateTerm, b: serviceTerm)
            let generalAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.black.cgColor
            ]
            let linkAttributes: [NSAttributedString.Key: Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.primaryColor?.cgColor ?? UIColor.blue.cgColor
            ]
            let mutableString: NSMutableAttributedString = NSMutableAttributedString()
            mutableString.append(NSAttributedString(string: guideText, attributes: generalAttributes))
            mutableString.setAttributes(linkAttributes, range: (guideText as NSString).range(of: serviceTerm))
            mutableString.setAttributes(linkAttributes, range: (guideText as NSString).range(of: privateTerm))
            
            $0.attributedText = mutableString
            $0.sizeToFit()
        }
        
        [loginButton].forEach{
            $0.backgroundColor = .primaryColor
            $0.setTitle("Sign In".localized(), for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.layer.cornerRadius = 20
        }
        
        [signupButton].forEach{
            $0.setTitle("Sign Up".localized(), for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.setTitleColor(.primaryColor, for: .normal)
        }
        
        [googleButton, kakaoButton, appleButton].forEach{
            $0.layer.cornerRadius = 20
            $0.layer.borderWidth = 0.2
            $0.layer.borderColor = UIColor.lightGray.cgColor
        }
        googleButton.setImage(UIImage(named: "google_logo"), for: .normal)
        googleButton.setImage(UIImage(named: "google_logo"), for: .highlighted)
        kakaoButton.setImage(UIImage(named: "kakao_logo"), for: .normal)
        kakaoButton.setImage(UIImage(named: "kakao_logo"), for: .highlighted)
        appleButton.setImage(UIImage(named: "apple_logo"), for: .normal)
        appleButton.setImage(UIImage(named: "apple_logo"), for: .highlighted)
        
        [loadingView].forEach{
            $0.backgroundColor = .gray.withAlphaComponent(0.9)
            $0.layer.cornerRadius = 20
        }
        [loadingIndicator].forEach{
            $0.color = .white
            $0.style = .large
        }
    }
    //UI
    private func setUI(){
        [introView, loginPannel].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [welcomeLabel, descLabel].forEach{
            introView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [usernameField, passwordField].forEach{
            loginPannel.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let termsAgreement: UIStackView = UIStackView(arrangedSubviews: [agreeButton, termsLabel])
        [termsAgreement].forEach{
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 8
            loginPannel.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let loginBtnStack: UIStackView = UIStackView()
        [loginButton, signupButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            loginBtnStack.addArrangedSubview($0)
        }
        [loginBtnStack].forEach{
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .equalSpacing
            $0.spacing = 10
            loginPannel.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let snsBtnStack: UIStackView = UIStackView()
        [googleButton, kakaoButton, appleButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            snsBtnStack.addArrangedSubview($0)
        }
        [snsBtnStack].forEach{
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalSpacing
            $0.spacing = 16
            loginBtnStack.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [loadingView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [loadingIndicator].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            loadingView.addSubview($0)
        }
        
        
        NSLayoutConstraint.activate([
            loginPannel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginPannel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginPannel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            introView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            introView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            introView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            introView.bottomAnchor.constraint(equalTo: loginPannel.topAnchor),
            
            welcomeLabel.leadingAnchor.constraint(equalTo: introView.leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: introView.trailingAnchor, constant: -16),
            welcomeLabel.centerYAnchor.constraint(equalTo: introView.centerYAnchor, constant: -20),
            descLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
            descLabel.centerYAnchor.constraint(equalTo: introView.centerYAnchor, constant: 28),
            
            usernameField.topAnchor.constraint(equalTo: loginPannel.topAnchor, constant: 16),
            usernameField.centerXAnchor.constraint(equalTo: loginPannel.centerXAnchor),
            usernameField.leadingAnchor.constraint(equalTo: loginPannel.leadingAnchor, constant: 32),
            usernameField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalTo: usernameField.heightAnchor),
            
            termsAgreement.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            termsAgreement.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsAgreement.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            termsAgreement.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            loginBtnStack.topAnchor.constraint(equalTo: termsAgreement.bottomAnchor, constant: 16),
            loginBtnStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            loginButton.widthAnchor.constraint(equalToConstant: 110),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            signupButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor),
            signupButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor),
            
//            snsBtnStack.heightAnchor.constraint(equalTo: loginButton.heightAnchor),
            snsBtnStack.heightAnchor.constraint(equalToConstant: 42),
            googleButton.widthAnchor.constraint(equalTo: googleButton.heightAnchor),
            kakaoButton.widthAnchor.constraint(equalTo: kakaoButton.heightAnchor),
            appleButton.widthAnchor.constraint(equalTo: appleButton.heightAnchor),
            
            loginBtnStack.bottomAnchor.constraint(equalTo: loginPannel.bottomAnchor, constant: -16),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.heightAnchor.constraint(equalTo: loadingView.widthAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 100),
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
        ])
    }
}

