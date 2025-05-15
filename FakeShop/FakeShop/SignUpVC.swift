//
//  SignUpVC.swift
//  FakeShop
//
//  Created by 이태형 on 12/19/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpVC: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: SignUpViewModel = SignUpViewModel()
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentScrollView: UIView = UIView()
    private let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    private let idTextField: UITextField = UITextField() //username
    private let idGuideLabel: UILabel = UILabel()
    private let pwTextField: UITextField = UITextField()
    private let pwGuideLabel: UILabel = UILabel()
    private let pwConfirmTextField: UITextField = UITextField()
    private let pwConfirmGuideLabel: UILabel = UILabel()
    private let firstnameTextField: UITextField = UITextField()
    private let firstNameGuideLabel: UILabel = UILabel()
    private let lastnameTextField: UITextField = UITextField()
    private let lastNameGuideLabel: UILabel = UILabel()
    private let emailTextField: UITextField = UITextField()
    private let emailGuideLabel: UILabel = UILabel()
    private let addressTextField: UITextField = UITextField()
    private let addressGuideLabel: UILabel = UILabel()
    private let phoneTextField: UITextField = UITextField()
    private let phoneGuideLabel: UILabel = UILabel()
    private let testMessage: UILabel = UILabel()
    private let signUpButton: UIButton = UIButton()
    private let loadingView: UIView = UIView()
    private let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setViewConfig()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}

#Preview("SignUpView"){
    return UINavigationController(rootViewController: SignUpVC())
}
#Preview("LoginView"){
    return UINavigationController(rootViewController: LoginVC())
}

//MARK: - Function
extension SignUpVC{
    @objc func didTapGesture(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let currentTextField = UIResponder.currentResponder as? UITextField else { return }
        scrollView.contentInset.bottom = keyboardFrame.size.height
        scrollView.scrollRectToVisible(currentTextField.frame, animated: true)
    }
    
    @objc func keyboardWillHide(_ sender: Notification){
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
}

//MARK: - BindViewModel
extension SignUpVC{
    private func bindViewModel(){
        let input: SignUpInput = SignUpInput(
            idText: idTextField.rx.text.orEmpty.asObservable(),
            pwText: pwTextField.rx.text.orEmpty.asObservable(),
            pwConfirmText: pwConfirmTextField.rx.text.orEmpty.asObservable(),
            firstNameText: firstnameTextField.rx.text.orEmpty.asObservable(),
            lastNameText: lastnameTextField.rx.text.orEmpty.asObservable(),
            emailText: emailTextField.rx.text.orEmpty.asObservable(),
            addressText: addressTextField.rx.text.orEmpty.asObservable(),
            phoneText: phoneTextField.rx.text.orEmpty.asObservable(),
            signUpTap: signUpButton.rx.tap.asObservable()
        )
        let output: SignUpOutput = viewModel.signUpLogic(input: input)
        
        output.idValid
            .bind(to: idGuideLabel.rx.text)
            .disposed(by: disposeBag)
        output.pwValid
            .bind(to: pwGuideLabel.rx.text)
            .disposed(by: disposeBag)
        output.pwConfirmValid
            .bind(to: pwConfirmGuideLabel.rx.text)
            .disposed(by: disposeBag)
        output.firstNameValid
            .bind(to: firstNameGuideLabel.rx.text)
            .disposed(by: disposeBag)
        output.lastNameValid
            .bind(to: lastNameGuideLabel.rx.text)
            .disposed(by: disposeBag)
        output.emailValid
            .bind(to: emailGuideLabel.rx.text)
            .disposed(by: disposeBag)
        output.addressValid
            .bind(to: addressGuideLabel.rx.text)
            .disposed(by: disposeBag)
        output.phoneValid
            .bind(to: phoneGuideLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isLoading.map{!$0}
            .observe(on: MainScheduler.instance)
            .bind(to: loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        output.isLoading
            .observe(on: MainScheduler.instance)
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.signUpResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else{return}
                
                switch result{
                case .success:
                    self.present(UIAlertController.messageAlert(title: nil, message: "Sign-up complete. You can now log in with your new account.".localized(), completion: {
                        self.navigationController?.popViewController(animated: true)
                    }), animated: true)
                case .failure(let error):
                    self.present(UIAlertController.messageAlert(title: nil, message: error.validMessage, completion: nil), animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }
}
//MARK: - SETUP
extension SignUpVC{
    private func setViewConfig(){
        setNavigationBar()
        setAttribute()
        setUI()
        bindViewModel()
    }
    
    private func setNavigationBar(){
        self.title = "Sign Up".localized()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [
            .foregroundColor : UIColor.white,
            .font : UIFont.boldSystemFont(ofSize: 22)
        ]
        appearance.backgroundColor = UIColor.primary
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func setAttribute(){
        view.backgroundColor = .white
        
        tapGesture.addTarget(self, action: #selector(didTapGesture(_:)))
        contentScrollView.addGestureRecognizer(tapGesture)
        
        [idTextField, pwTextField, pwConfirmTextField, firstnameTextField, lastnameTextField, emailTextField, addressTextField, phoneTextField].forEach{
            $0.delegate = self
        }
        [pwTextField, pwConfirmTextField].forEach{
            $0.isSecureTextEntry = true
            $0.textContentType = .oneTimeCode
        }
        emailTextField.keyboardType = .emailAddress
        phoneTextField.keyboardType = .numberPad
        
        
        [testMessage].forEach{
            $0.text = "You will not actually be able to register as a member.".localized()
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .gray
        }
        
        [signUpButton].forEach{
            $0.setTitle("Sign Up".localized(), for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .primary
            $0.layer.cornerRadius = 20
        }
        
        [loadingView].forEach{
            $0.backgroundColor = .gray.withAlphaComponent(0.9)
            $0.layer.cornerRadius = 20
        }
        [loadingIndicator].forEach{
            $0.color = .white
            $0.style = .large
        }
    }
    
    private func setUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentScrollView)
        [scrollView, contentScrollView].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let textFieldStack: UIStackView = {
            let stackView: UIStackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .equalSpacing
            stackView.spacing = 8
            let textFields: [UITextField] = [idTextField, pwTextField, pwConfirmTextField, firstnameTextField, lastnameTextField, emailTextField, addressTextField, phoneTextField]
            let guideLabels: [UILabel] = [idGuideLabel, pwGuideLabel, pwConfirmGuideLabel, firstNameGuideLabel, lastNameGuideLabel, emailGuideLabel, addressGuideLabel, phoneGuideLabel]
            if textFields.count == TextFieldType.allCases.count - 1 {
                for idx in 0..<textFields.count{
                    stackView.addArrangedSubview(TextFieldRow(TextFieldType(rawValue: idx) ?? TextFieldType.error, textFields[idx], guideLabels[idx]))
                }
            }
            return stackView
        }()
        contentScrollView.addSubview(textFieldStack)
        textFieldStack.translatesAutoresizingMaskIntoConstraints = false
        
        [testMessage, signUpButton].forEach{
            contentScrollView.addSubview($0)
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
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentScrollView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            textFieldStack.topAnchor.constraint(equalTo: contentScrollView.topAnchor, constant: 10),
            textFieldStack.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            textFieldStack.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            
            testMessage.topAnchor.constraint(equalTo: textFieldStack.bottomAnchor, constant: 20),
            testMessage.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),
            testMessage.leadingAnchor.constraint(greaterThanOrEqualTo: contentScrollView.leadingAnchor, constant: 20),
            
            signUpButton.topAnchor.constraint(equalTo: testMessage.bottomAnchor, constant: 8),
            signUpButton.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 100),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
//            signUpButton.leadingAnchor.constraint(greaterThanOrEqualTo: contentScrollView.leadingAnchor, constant: 20),
            signUpButton.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: -30),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.heightAnchor.constraint(equalTo: loadingView.widthAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 100),
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
        ])
    }
}


//MARK: - Delegate
extension SignUpVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case idTextField:
            pwTextField.becomeFirstResponder()
        case pwTextField:
            pwConfirmTextField.becomeFirstResponder()
        case pwConfirmTextField:
            firstnameTextField.becomeFirstResponder()
        case firstnameTextField:
            lastnameTextField.becomeFirstResponder()
        case lastnameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            addressTextField.becomeFirstResponder()
        case addressTextField:
            phoneTextField.becomeFirstResponder()
//        case phoneTextField:
        default:
            return false
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField{
        case idTextField, pwTextField, pwConfirmTextField, firstnameTextField, lastnameTextField, emailTextField, addressTextField:
            guard let text = textField.text else{return true}
            guard text.count < 20 else{return false}
            return true
        case phoneTextField:
            guard let text = textField.text else{return true}
            if string == "" {
                if text.count == 5 || text.count == 10 {
                    textField.text?.removeLast()
                }
                return true
            } else {
                guard let _ = Int(string) else{return false}
                guard text.count < 13 else{return false}
                if text.count == 3 || text.count == 8 {
                    textField.text?.append("-")
                }
                return true
            }
        default: return true
        }
    }
}

