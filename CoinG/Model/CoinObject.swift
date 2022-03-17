//
//  CoinObject.swift
//  CoinG
//
//  Created by Gleb Lanin on 12/03/2022.
//

import Foundation
import RealmSwift

class CoinObject: Object{
    @Persisted var entityKey: String = NSUUID().uuidString
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var symbol: String
    @Persisted var price: Double
    @Persisted var change24h: Double?
    @Persisted var imageUrl: String
    @Persisted var position: Int
    @Persisted var bookmarked: Bool
    @Persisted var timeCreated: Date?
     
    convenience init(id: String, name: String, symbol: String, price: Double, change24: Double, position: Int, url: String){
        self.init()
        self.id = id
        self.name = name
        self.symbol = symbol
        self.price = price
        self.change24h = change24
        self.position = position
        self.imageUrl = url
        self.bookmarked = false
    }
    
    override static func primaryKey() -> String? {
        return "entityKey"
      }
}
