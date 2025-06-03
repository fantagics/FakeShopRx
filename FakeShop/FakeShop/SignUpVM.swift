//
//  SignUpVM.swift
//  FakeShop
//
//  Created by 이태형 on 12/26/24.
//

import UIKit
import RxSwift
import RxRelay

class SignUpViewModel{
    private let disposeBag = DisposeBag()
    private let loading = BehaviorRelay<Bool>(value: false)
    private let req: AuthRequestRx = AuthRequestRx()
    
    func signUpLogic(input: SignUpInput) -> SignUpOutput{
        let idValidation: Observable<String> = input.idText.map{ self.guideMessageValid($0, .id) }
        let pwValidation: Observable<String> = input.pwText.map{ self.guideMessageValid($0, .password) }
        let pwConfirmValidation: Observable<String> = Observable.combineLatest(input.pwText, input.pwConfirmText).map{ pw, pwConfirm in
            return pw == pwConfirm ? "" : TextFieldType.confirmPassword.guideMessage
        }
        let firstNameValidation: Observable<String> = input.firstNameText.map{ self.guideMessageValid($0, .firstName) }
        let lastNameValidation: Observable<String> = input.lastNameText.map{ self.guideMessageValid($0, .lastName) }
        let emailValidation: Observable<String> = input.emailText.map{ self.guideMessageValid($0, .email) }
        let addressValidation: Observable<String> = input.addressText.map{ self.guideMessageValid($0, .address) }
        let phoneValidation: Observable<String> = input.phoneText.map{ self.guideMessageValid($0, .phone) }
        
        let idGuide: Observable<String> = idValidation.skip(1).startWith("")
        let pwGuide: Observable<String> = pwValidation.skip(1).startWith("")
        let pwConfirmGuide: Observable<String> = pwConfirmValidation.skip(1).startWith("")
        let firstNameGuide: Observable<String> = firstNameValidation.skip(1).startWith("")
        let lastNameGuide: Observable<String> = lastNameValidation.skip(1).startWith("")
        let emailGuide: Observable<String> = emailValidation.skip(1).startWith("")
        let addressGuide: Observable<String> = addressValidation.skip(1).startWith("")
        let phoneGuide: Observable<String> = phoneValidation.skip(1).startWith("")
        
        let isFormValid = Observable.combineLatest(
            idValidation, pwValidation, pwConfirmValidation, firstNameValidation, lastNameValidation, emailValidation, addressValidation, phoneValidation
        ){
            $0.isEmpty && $1.isEmpty && $2.isEmpty && $3.isEmpty && $4.isEmpty && $5.isEmpty && $6.isEmpty && $7.isEmpty
        }.share(replay: 1)
        
        let credentials = Observable.combineLatest(input.idText, input.pwText, input.firstNameText, input.lastNameText, input.emailText, input.addressText, input.phoneText){
            SignUpInfomation(id: $0, pw: $1, firstName: $2, lastName: $3, email: $4, address: $5, phone: $6)
        }.share(replay: 1)
        
        let resultSubject = PublishSubject<Result<Void, SignUpError>>()
        
//        input.signUpTap
//            .withLatestFrom(Observable.combineLatest(credentials, isFormValid))
//            .flatMapLatest { [weak self] (info, isValid) -> Observable<Result<Void, SignUpError>> in
//                guard let self = self, !self.loading.value else { return .empty() }
//                self.loading.accept(true)
//                
////                return .just(.failure(.idError))
//                return req.signUpMock(id: "info.id", pw: "info.pw", firstName: "info.firstName", lastName: "info.lastName", email: "info.email", address: "info.address", phone: "info.phone")
//                    .map{ _ in .success(()) }
//                    .catch{ err in
//                            .just(.failure(.anonymousError(err.localizedDescription)))
//                    }
//                    .do(onDispose: {
//                        self.loading.accept(false)
//                    })
//            }
//            .bind(to: resultSubject)
//            .disposed(by: disposeBag)
        
        input.signUpTap
            .withLatestFrom(Observable.combineLatest(credentials, isFormValid))
            .flatMapLatest { [weak self] (info, isValid) -> Observable<Result<Void, SignUpError>> in
                guard let self = self, !self.loading.value else { return .empty() }
                
                if !isValid {
                    return Observable.combineLatest(idValidation, pwValidation, pwConfirmValidation, firstNameValidation, lastNameValidation, emailValidation, addressValidation, phoneValidation)
                        .take(1)
                        .map{ idValidation, pwValidation, pwConfirmValidation, firstNameValidation, lastNameValidation, emailValidation, addressValidation, phoneValidation in
                            if !idValidation.isEmpty {return .failure(.idError)}
                            if !pwValidation.isEmpty {return .failure(.pwError)}
                            if !pwConfirmValidation.isEmpty {return .failure(.confirmPwError)}
                            if !firstNameValidation.isEmpty {return .failure(.firstNameError)}
                            if !lastNameValidation.isEmpty {return .failure(.lastNameError)}
                            if !emailValidation.isEmpty {return .failure(.emailError)}
                            if !addressValidation.isEmpty {return .failure(.addressError)}
                            if !phoneValidation.isEmpty {return .failure(.phoneError)}
                            return .failure(.anonymousError("Anonymous Error in SignUp Validation."))
                        }
                }
                
                self.loading.accept(true)
                
//                return req.signUp(id: info.id, pw: info.pw, firstName: info.firstName, lastName: info.lastName, email: info.email, address: info.address, phone: info.phone)
                return req.signUpMock(id: info.id, pw: info.pw, firstName: info.firstName, lastName: info.lastName, email: info.email, address: info.address, phone: info.phone)
                    .map{ _ in .success(()) }
                    .catch{ err in
                            .just(.failure(.anonymousError(err.localizedDescription)))
                    }
                    .do(onDispose: {
                        self.loading.accept(false)
                    })
            }
            .bind(to: resultSubject)
            .disposed(by: disposeBag)
        
        return SignUpOutput(
            idValid: idGuide,
            pwValid: pwGuide,
            pwConfirmValid: pwConfirmGuide,
            firstNameValid: firstNameGuide,
            lastNameValid: lastNameGuide,
            emailValid: emailGuide,
            addressValid: addressGuide,
            phoneValid: phoneGuide,
            signUpEnable: isFormValid,
            signUpResult: resultSubject,
            isLoading: loading.asObservable()
        )
    }
    
    private func guideMessageValid(_ text: String, _ textType: TextFieldType) -> String{
        switch textType{
        case .id, .password, .email, .phone:
            return regexValid(text, textType) ? "" : textType.guideMessage
        case .firstName, .lastName, .address:
            return !text.isEmpty ? "" : textType.guideMessage
        default: return TextFieldType.error.guideMessage
        }
    }
    
    private func regexValid(_ text: String, _ textType: TextFieldType) -> Bool {
        let pattern: String = textType.validPattern
        return text.range(of: pattern, options: .regularExpression) != nil
    }
    
    struct SignUpInfomation {
        let id: String
        let pw: String
        let firstName: String
        let lastName: String
        let email: String
        let address: String
        let phone: String
    }
}
