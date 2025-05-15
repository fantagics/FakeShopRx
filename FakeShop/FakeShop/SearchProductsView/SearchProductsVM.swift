//
//  SearchProductsVM.swift
//  FakeShop
//
//  Created by 이태형 on 3/4/25.
//

import UIKit

class SearchProductsVM{
    var receivedProducts: [Product] = []
    var filteredProducts: [Product] = []
    var prevSearchText: String = ""
    var searchText: String = ""
    var sortedProducts: [Product] = []
    var sortType: SortType = .recent
    let paginationCount = 8
    var showCount: Int = 0
    
    func getProducts(category: String, completion: (()-> ())?){ //Changed Category
        ProductRequest.products(category: category){ res in
            switch res{
            case .success(let data):
                self.receivedProducts = data
                self.sortProducts()
                (completion ?? {})()
            case .failure(let err):
                print("Error: getCategories:", err.localizedDescription)
            }
        }
    }
    
    func sortProducts(){
        if prevSearchText != searchText{
            prevSearchText = searchText
            filteredProducts = searchText.count > 0 ? receivedProducts.filter{ $0.title.lowercased().contains(searchText) } : receivedProducts
        } else if searchText.count == 0 {
            filteredProducts = receivedProducts
        }
        
        switch self.sortType {
        case .recent:
            sortedProducts = filteredProducts.sorted(by: { $0.id < $1.id })
            break
        case .highPrice:
            sortedProducts = filteredProducts.sorted(by: { $0.price > $1.price })
            break
        case .lowPrice:
            sortedProducts = filteredProducts.sorted(by: { $0.price <= $1.price })
            break
        case .rating:
            sortedProducts = filteredProducts.sorted(by: { $0.rating.rate > $1.rating.rate })
            break
        case .sellCount:
            sortedProducts = filteredProducts.sorted(by: { $0.rating.count > $1.rating.count })
            break
        }
    }
    
    func pagination(isPossible: inout Bool){
        if sortedProducts.count < showCount + paginationCount {
            print("\(sortedProducts.count) / \(showCount) + \(paginationCount)")
            showCount = sortedProducts.count
            isPossible = false
            print("Pagination False. count:", showCount)
        } else{
            showCount += paginationCount
            print("showCount:", showCount)
        }
    }
}
