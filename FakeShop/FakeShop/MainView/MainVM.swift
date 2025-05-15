//
//  MainVM.swift
//  FakeShop
//
//  Created by 이태형 on 2/2/25.
//

import UIKit

class MainVM{
    
//    func getCategories(completion: @escaping (Result<Void,Error>) -> Void){
    func getCategories(){
        Common.shared.categories = ["all"]
        ProductRequest.categories(){ res in
            switch res{
            case .success(let data):
                Common.shared.categories += data
                NotificationCenter.default.post(name: Notification.Name("receiveCategory"), object: nil, userInfo: nil)
//                completion(.success(()))
            case .failure(let err):
                print("Error: getCategories:", err.localizedDescription)
//                completion(.failure(err))
            }
        }
    }
    
    func getPreviewItems(){
        for idx in 1..<Common.shared.categories.count{
            ProductRequest.products(category: Common.shared.categories[idx], count: 3){ res in
                switch res{
                case .success(let data):
                    NotificationCenter.default.post(name: Notification.Name("reloadPreviewItems"), object: nil, userInfo: ["pushData": data])
                case .failure(let err):
                    print("Error: getCategories:", err.localizedDescription)
                }
            }
        }
    }
    
}
