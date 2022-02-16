//
//  CoinObjects.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 03/02/2022.
//

import Foundation
import RealmSwift

class CoinObjects: Object {
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var price: Float
    @Persisted var isCrypto: Int
    @Persisted var image: Data
}


