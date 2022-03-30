//
//  PickerView.swift
//  CoinG
//
//  Created by Gleb Lanin on 15/03/2022.

import UIKit
import Combine
class PickerView: UIView{
    
    //var selectedCurrency = CurrentValueSubject<String, Never>("usd")
    //var subscriptions = Set<AnyCancellable>()
    
    let manager = CryptoManager()
    let defaults = UserDefaults.standard
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 4
    var selectedRow = 0
    //var selectedRowTextColor = 0
    
    var arr = Constants.currencySet
    
    func addAlert(with title: String = "Choose curency", on viewController: UIViewController){
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: true)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.backgroundColor = .gray
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            let selectedCurrency = self.arr[self.selectedRow].lowercased()
            self.defaults.set(selectedCurrency, forKey: Constants.currencyKey)
            self.manager.cancelTask()
            self.manager.performRequests(for: selectedCurrency)
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = arr[row]
        
        print("Currency now is \(selected)")
    }
}
