//
//  NetworkErrors.swift
//  FakeShop
//
//  Created by 이태형 on 2/2/25.
//

import UIKit

enum LoginError: Error{
    case rejectAgreement
    case idEmpty
    case pwEmpty
    case unConected
    case fail
    
    var message: String{
        switch self{
        case .rejectAgreement: "Please agree to the Privacy Policy and Terms of Service."
        case .idEmpty: "Please enter your ID"
        case .pwEmpty: "Please enter your Password"
        case .unConected: "Login failed. Please check your network connection."
        case .fail: "Login failed. Please check your ID and password again. If the same problem persists, please contact us."
        }
    }
}
