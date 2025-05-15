//
//  AuthModel.swift
//  FakeShop
//
//  Created by 이태형 on 1/16/25.
//

import Foundation

struct SignUpRes: Codable{
    let id: Int
    let username, password, email, phone: String
    let name: NameEn
    let address: AddressEn
    
    struct NameEn: Codable{
        let firstname, lastname: String
    }
    struct AddressEn: Codable{
        let city, street, zipcode: String
        let number: Int
        let geolocation: GeolocationEn
        
        struct GeolocationEn: Codable{
            let lat, long: String
        }
    }
}

struct UserToken: Codable{
    let token: String
}

enum LoginType: String{
    case none = "none"
    case email = "email"
    case kakao = "kakao"
    case google = "google"
    case apple = "apple"
}
