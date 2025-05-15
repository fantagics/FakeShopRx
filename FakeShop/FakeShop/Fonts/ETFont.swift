//
//  ETFont.swift
//  FakeShop
//
//  Created by 이태형 on 2/5/25.
//

import UIKit

extension UIFont{
    class func NanumGothic(type: NanumGothicType, size: CGFloat) -> UIFont! {
        guard let font = UIFont(name: type.name, size: size) else{return nil}
        return font
    }
}

enum NanumGothicType{
    case Regular
    case Bold
    case ExtraBold
    
    var name: String{
        switch self{
        case .Regular: return "NanumGothic"
        case .Bold: return "NanumGothicBold"
        case .ExtraBold: return "NanumGothicExtraBold"
        }
    }
}
