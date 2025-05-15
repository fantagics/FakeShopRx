//
//  ETURL.swift
//  FakeShop
//
//  Created by 이태형 on 2024/08/07.
//

import Foundation

extension URL{
    static let serviceTermsUrl = URL(string: "https://www.google.co.kr")!
    static let privateTermsUrl = URL(string: "https://www.naver.com")!
    static let signUpUrl = finalUrl("users")
    static let logInUrl = finalUrl("auth/login")
    static let categoriesUrl = finalUrl("products/categories")
    
    static func getItems(category: String = "all", count: Int = 0, desc: Bool = false)->URL{
        var path: String = category == "all" ? "products" : "products/category/\(category)"
        let prv: Int = path.count
        if desc {
            path += "?sort=desc"
        }
        if count > 0{
            path += path.count > prv ? "&" : "?"
            path += "limit=\(count)"
        }
        return finalUrl(path)
    }
    
    static func finalUrl(_ endPoint: String)-> URL{
        var urlStr: String = ""
    #if DEBUG
        urlStr = "https://fakestoreapi.com/"
    #elseif RELEASE
        urlStr = "https://fakestoreapi.com/"
    #endif
        return URL(string: "\(urlStr)\(endPoint)")!
    }
}
