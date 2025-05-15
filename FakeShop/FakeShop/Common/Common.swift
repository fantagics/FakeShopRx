//
//  Common.swift
//  FakeShop
//
//  Created by 이태형 on 1/16/25.
//

import UIKit

class Common{
    static let shared: Common = Common()
    private init(){}
    
    var token: String = ""
    var loginType: LoginType = .none
    let noticeArr: [UIImage] = ["event_0", "event_1", "event_2"].map{UIImage(named: $0)}.compactMap{$0}
    var categories: [String] = []
    
    let dummyProduct: Product = Product(id: 1, title: "WD 2TB Elements Portable External Hard Drive - USB 3.0", price: 64.0, description: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.", category: "electronics", image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg", rating: Rating(rate: 3.8, count: 203))
}

