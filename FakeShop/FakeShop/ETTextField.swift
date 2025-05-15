//
//  ETTextField.swift
//  FakeShop
//
//  Created by 이태형 on 2024/08/04.
//⟶

import UIKit

extension UITextField{
    func addLeftPadding(_ value: CGFloat = 10) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
}
