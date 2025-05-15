//
//  PickerViewForActionSheet.swift
//  FakeShop
//
//  Created by 이태형 on 3/5/25.
//

import UIKit

//Piker for ActionSheet
extension SearchProductsVC: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker{
            return Common.shared.categories.count
        } else if pickerView == sortTypePicker{
            return SortType.allCases.count
        } else{return 0}
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker{
            return Common.shared.categories[row].localized()
        } else if pickerView == sortTypePicker{
            return SortType(rawValue: row)?.str.localized() ?? "error"
        } else {return nil}
    }
}
