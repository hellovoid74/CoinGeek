//
//  CalculatorViewController.swift
//  CoinG
//
//  Created by Gleb Lanin on 31/03/2022.
//

import UIKit
import SnapKit
import Combine

class CalculatorViewController: UIViewController {
    
    private let inputField = UITextField()
    private let outputField = UITextField()
    private let coinLabel = UILabel()
    private let currencyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = Colors.side
        [inputField, outputField].forEach {
            configureField($0)
            view.addSubview($0)
        }
        
        let dist = self.view.frame.width/4
        
        inputField.snp.makeConstraints {
            $0.left.equalTo(view.safeArea.left).offset(dist/2)
            $0.top.equalTo(view.safeArea.top).offset(100)
            $0.width.equalTo(dist)
            $0.height.equalTo(50)
        }
        outputField.snp.makeConstraints {
            $0.left.equalTo(inputField.snp.right).offset(dist)
            $0.top.equalTo(view.safeArea.top).offset(100)
            $0.width.equalTo(dist)
            $0.height.equalTo(50)
        }
    }
    
    func configureField(_ field: UITextField) {
        field.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        field.backgroundColor = .white
        field.clipsToBounds = true
        field.layer.cornerRadius = 15
    }
}
