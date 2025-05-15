//
//  NoticeImageFooter.swift
//  FakeShop
//
//  Created by 이태형 on 2/10/25.
//

import UIKit

class NoticeFooter: UICollectionReusableView{
    static let identifier: String = String(describing: NoticeFooter.self)
    
    let pageControl: UIPageControl = UIPageControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        [pageControl].forEach{
            $0.pageIndicatorTintColor = .gray
            $0.currentPageIndicatorTintColor = .primary
            $0.numberOfPages = Common.shared.noticeArr.count
            $0.currentPage = 0
            $0.isUserInteractionEnabled = false
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: self.topAnchor),
            pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pageControl.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
