//
//  ETDouble.swift
//  FakeShop
//
//  Created by 이태형 on 2/15/25.
//

import UIKit

extension Double{
    func toCurrencyFormat()-> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 2
        guard var price = formatter.string(for: self)else{
            return "Formatter Error"
        }
        price.insert(" ", at: price.index(price.startIndex, offsetBy: 1))
        return price
    }
}
