//
//  UserInfoM.swift
//  FakeShop
//
//  Created by 이태형 on 5/31/25.
//

import Foundation

enum SettingMenu: Int, CaseIterable{
    case userInfo
    case orderHistory
    case cart
    case inquiryHistory
    case logout
    
    var str: String{
        switch self{
        case .orderHistory: "orderHistory"
        case .cart: "cart"
        case .inquiryHistory: "inquiryHistory"
        case .logout: "logout"
        default: "error"
        }
    }
    
    var icon: String{
        switch self{
        case .orderHistory: "list.bullet"
        case .cart: "cart"
        case .inquiryHistory: "info.circle"
        case .logout: "rectangle.portrait.and.arrow.right"
        default: "questionmark.circle"
        }
    }
}
