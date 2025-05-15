//
//  ProductModel.swift
//  FakeShop
//
//  Created by 이태형 on 2/2/25.
//

import Foundation

struct Product: Codable{
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
}

struct Rating: Codable{
    let rate: Double
    let count: Int
}

enum Purchase{
    case buy
    case cart
    case none
    
    var str: String{
        switch self{
        case .buy: return "buy"
        case .cart: return "cart"
        case .none: return "error"
        }
    }
}

enum SortType: Int, CaseIterable{
    case recent //$0.id > $1.id
    case highPrice
    case lowPrice
    case rating
    case sellCount
    
    var str: String{
        switch self{
        case .recent: return "Newest Arrivals"
        case .highPrice: return "Price: High To Low"
        case .lowPrice: return "Price: Low to High"
        case .rating: return "Avg. Customer Review"
        case .sellCount: return "Best Sellers"
        }
    }
}

