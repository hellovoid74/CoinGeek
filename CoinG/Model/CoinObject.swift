//
//  CoinObject.swift
//  CoinG
//
//  Created by Gleb Lanin on 12/03/2022.
//

import Foundation
import RealmSwift
import Combine


class CoinObject: Object {
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
    @Persisted var currency: String
     
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
        self.currency = currency
    }
    
    override static func primaryKey() -> String? {
        return "entityKey"
      }
}

class SelectedCurrency: Object {
    @Persisted var currency: String
    
    convenience init(currency: String){
        self.init()
        self.currency = "usd"
    }
}


class Coins: ObservableObject {

    @Published var coins: Results<CoinObject>?
    private var subscriptions = Set<AnyCancellable>()

    init() {
        let realm = try! Realm()
        realm.objects(CoinObject.self)
            .changesetPublisher
            .receive(on: DispatchQueue.main)
            .sink { changeset in
                self.applyChangeset(changeset)
        }
        .store(in: &subscriptions)
    }

    func applyChangeset(_ changes: RealmCollectionChange<Results<CoinObject>>) {
        switch changes {
        case .initial(let results):
            self.coins = results
        case .update(let results, deletions: _, insertions: _, modifications: _):
            self.coins = results
            self.objectWillChange.send()         
        case .error(let error):
            print(error.localizedDescription)
        }
    }
}
