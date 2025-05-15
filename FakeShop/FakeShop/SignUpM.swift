//
//  SignUpM.swift
//  FakeShop
//
//  Created by 이태형 on 12/26/24.
//

import Foundation
import RxSwift

enum TextFieldType: Int, CaseIterable{
    case id
    case password
    case confirmPassword
    case firstName
    case lastName
    case email
    case address
    case phone
    case error
    
    var title: String{
        switch self{
            case .id: return "id"
            case .password : return "password"
            case .confirmPassword : return "confirm password"
            case .firstName : return "first name"
            case .lastName : return "last name"
            case .email : return "email"
            case .address : return "address"
            case .phone : return "phone"
            default: return "error"
        }
    }
    
    var placeholder: String{
        switch self{
        case .id: return "8+ characters, letters and numbers".localized()
        case .password : return "8+ characters, letters, numbers, and special characters.".localized()
        case .confirmPassword : return "Re-enter password".localized()
        case .firstName : return "First Name".localized()
        case .lastName : return "Last Name".localized()
        case .email : return "example@site.type".localized()
        case .address : return "Address".localized()
        case .phone : return "010-0000-0000".localized()
        default: return "error"
        }
    }
    
    var validPattern: String{
        switch self{
            case .id: return "^[a-zA-Z0-9]{8,20}$"
            case .password: return "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=;':,.<>?\"]).{8,20}$"
//            case .confirmPassword: return ""
//            case .firstName: return ""
//            case .lastName: return ""
            case .email: return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9]+\\.[a-z.]{2,}$"
//            case .address: return ""
            case .phone: return "^01[0-1 7][-][0-9]{4}[-][0-9]{4}$"
            default: return "error"
        }
    }
    
    var guideMessage: String{
        switch self{
        case .id: return "8~20 characters using upper/lowercase letters and numbers.".localized()
        case .password : return "At least 8 characters, including upper/lowercase letters, numbers, and special characters.".localized()
        case .confirmPassword : return "Passwords do not match.".localized()
        case .firstName : return "Invalid first name format.".localized()
        case .lastName : return "Invalid last name format.".localized()
        case .email : return "example@site.type".localized()
        case .address : return "Invalid adress format.".localized()
        case .phone : return "01*-****-****".localized()
            default: return "error"
        }
    }
}

enum SignUpError: Error{
    case idError
    case pwError
    case confirmPwError
    case firstNameError
    case lastNameError
    case emailError
    case addressError
    case phoneError
    case anonymousError(String)
    
    var validMessage: String{
        switch self{
        case .idError: return "Invalid ID. Please enter 8~20 characters using upper/lowercase letters and numbers.".localized()
        case .pwError : return "Invalid password. Please enter at least 8 characters, including upper/lowercase letters, numbers, and special characters.".localized()
        case .confirmPwError : return "Passwords do not match".localized()
        case .firstNameError : return "Please enter your first name (at least one character).".localized()
        case .lastNameError : return "Please enter your last name (at least one character).".localized()
        case .emailError : return "Invalid email format.".localized()
        case .addressError : return "Invalid adress format.".localized()
        case .phoneError : return "Invalid phone number format.".localized()
        case .anonymousError(let msg) : return "Error: \(msg)"
//            default: return "error"
        }
    }
}

struct SignUpInput{
    let idText: Observable<String>
    let pwText: Observable<String>
    let pwConfirmText: Observable<String>
    let firstNameText: Observable<String>
    let lastNameText: Observable<String>
    let emailText: Observable<String>
    let addressText: Observable<String>
    let phoneText: Observable<String>
    let signUpTap: Observable<Void>
}

struct SignUpOutput{
    let idValid: Observable<String>
    let pwValid: Observable<String>
    let pwConfirmValid: Observable<String>
    let firstNameValid: Observable<String>
    let lastNameValid: Observable<String>
    let emailValid: Observable<String>
    let addressValid: Observable<String>
    let phoneValid: Observable<String>
    let signUpEnable: Observable<Bool>
    let signUpResult: Observable<Result<Void, SignUpError>>
    let isLoading: Observable<Bool>
}
