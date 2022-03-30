//
//  CurrencyValue.swift
//  CoinG
//
//  Created by Gleb Lanin on 30/03/2022.
//

import Foundation
import RealmSwift

class CurrencyObject: Object {
    @Persisted var id: String
    
    convenience init(currency: String) {
        self.init()
        self.id = currency
    }
}

