//
//  UserInfoVM.swift
//  FakeShop
//
//  Created by 이태형 on 5/30/25.
//

import Foundation
import RxSwift
import RxCocoa

class UserInfoViewModel{
    struct Input {
        let selectedRow: Observable<IndexPath>
    }
    struct Output {
        let settingMenus: Driver<[SettingMenu]>
        let didTapUserInfo: Driver<Void>
        let didTapMenu: Driver<SettingMenu>
    }
    
    func tableViewLogic(input: Input) -> Output{
        let settingMenus = Observable.just(SettingMenu.allCases).asDriver(onErrorJustReturn: [])
        let didTapUserInfo = input.selectedRow
            .filter{ $0.row == 0 }
            .map{ _ in }
            .asDriver(onErrorDriveWith: .empty())
        let didTapMenu = input.selectedRow
            .filter{ $0.row > 0 }
            .compactMap{ SettingMenu(rawValue: $0.row) }
            .asDriver(onErrorDriveWith: .empty())
        return Output(settingMenus: settingMenus,
                      didTapUserInfo: didTapUserInfo,
                      didTapMenu: didTapMenu)
    }
}


