//
//  MyAlert.swift
//  CoinG
//
//  Created by Gleb Lanin on 15/03/2022.
//
import UIKit

class MyAlert: NSObject {
    
    func addAlert(with title: String = "Choose curency", on viewController: UIViewController){
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 100,height: 150)
        let alertView = UIView(frame: CGRect(x: 0, y: 20, width: 50, height: 150))
        alertView.backgroundColor = .yellow
        alertView.alpha = 1
        vc.view.addSubview(alertView)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 20, width: 100, height: 150))
        pickerView.delegate = self
        pickerView.dataSource = self
        alertView.addSubview(pickerView)
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.alert)
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(alert, animated: true)
    }
}

extension MyAlert: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.currencySet.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.currencySet[row]
    }
}


