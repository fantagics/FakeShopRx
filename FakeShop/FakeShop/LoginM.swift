//
//  LoginM.swift
//  FakeShop
//
//  Created by 이태형 on 5/17/25.
//

import Foundation
import RxSwift

struct LoginInput {
    let idText: Observable<String>
    let passwordText: Observable<String>
    let agreementChecked: Observable<Bool>
    let loginTap: Observable<Void>
}

struct LoginOutput{
//    let loginEnable: Observable<Bool>
    let loginResult: Observable<Result<Void, LoginError>>
    let isLoading: Observable<Bool>
}

enum LoginError: Error, Equatable{
    case invalidId
    case invalidPw
    case notAgreed
    case wrongAccount
    case networkNotConnected
    case networkError(String)
    case anonymousError(String)
    
    var validMessage: String{
        switch self{
        case .invalidId: return "Username must be at least 8 characters long.".localized()
        case .invalidPw: return "Password must be at least 8 characters long.".localized()
        case .notAgreed: return "Please agree to the Privacy Policy and Terms of Service.".localized()
        case .wrongAccount: return "Login failed. Please check your ID and password again. If the same problem persists, please contact us.".localized()
        case .networkNotConnected: return "Login failed. Please check your network connection.".localized()
        case .networkError(let msg) : return "Network Error: \(msg)"
        case .anonymousError(let msg) : return "Error: \(msg)"
        }
    }
}
