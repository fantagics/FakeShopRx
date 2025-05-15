//
//  ProductRequest.swift
//  FakeShop
//
//  Created by 이태형 on 2/2/25.
//

import UIKit
import Alamofire

class ProductRequest{
    static func categories(completion: @escaping (Result<[String], Error>)-> Void){
        AF.request(URL.categoriesUrl,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .validate(statusCode: 200..<300)
        .responseDecodable(of: [String].self){ res in
            switch res.result{
            case .success(let data):
                completion(.success(data))
            case .failure(let err):
                completion(.failure(err))
            }
            
        }
    }
    
    static func products(category: String = "all", count: Int = 0, desc: Bool = false, completion: @escaping (Result<[Product], Error>)-> Void){
        AF.request(URL.getItems(category: category,count: count, desc: desc),
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .validate(statusCode: 200..<300)
        .responseDecodable(of: [Product].self){ res in
            switch res.result{
            case .success(let data):
                print("Request Success:", data.count)
                completion(.success(data))
            case .failure(let err):
                print("Request Fail:", err.localizedDescription)
                completion(.failure(err))
            }
        }
    }
    
}
