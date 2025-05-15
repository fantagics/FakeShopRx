//
//  BannerCollectionViewCell.swift
//  FakeShop
//
//  Created by 이태형 on 2/11/25.
//

import UIKit
import ImageSlideshow

class BannerCollectionViewCell: UICollectionViewCell{
    static let identifier: String = String(describing: BannerCollectionViewCell.self)
    
    private var banner: ImageSlideshow = ImageSlideshow()
    private let pageIndicator: UIPageControl = UIPageControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SETUP
extension BannerCollectionViewCell{
    private func setViewConfig(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        [pageIndicator].forEach{
            $0.currentPageIndicatorTintColor = .primary
            $0.pageIndicatorTintColor = .gray
            $0.numberOfPages = Common.shared.noticeArr.count
        }
        
        [banner].forEach{
            $0.setImageInputs(Common.shared.noticeArr.map{ImageSource(image: $0)})
            $0.slideshowInterval = 3
            $0.isUserInteractionEnabled = true
            $0.pageIndicator = pageIndicator
        }
    }
    
    private func setUI(){
        [banner].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: self.topAnchor),
            banner.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            banner.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
