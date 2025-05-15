//
//  ETString.swift
//  FakeShop
//
//  Created by 이태형 on 4/14/25.
//

import Foundation

extension String{
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func localized(with argument: CVarArg = [], comment: String = "") -> String {
        return String(format: self.localized(comment: comment), argument)
    }
    func localized(a: CVarArg = [], b: CVarArg = [], comment: String = "") -> String {
        return String(format: self.localized(comment: comment), a, b)
    }
    func localized(a: CVarArg = [], b: CVarArg = [], c: CVarArg = [], comment: String = "") -> String {
        return String(format: self.localized(comment: comment), a, b, c)
    }
}
