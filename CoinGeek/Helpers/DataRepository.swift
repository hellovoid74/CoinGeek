//
//  DataRepository.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 19/02/2022.
//

import Foundation
import RealmSwift

class DataRepository {
    
    let realm = try! Realm()
    
    //MARK: - Load data from realm
    
    func loadObjects() -> Results<CoinObjects> {
        
        let arr = realm.objects(CoinObjects.self)
        return arr
    }
    
    //MARK: - Remove old data
    
    func removeOldData() {
        
        do {
            try realm.write {
                realm.delete(realm.objects(LogoObjects.self))
                realm.delete(realm.objects(CoinObjects.self))
            }
        } catch {
            print(String(describing: error))
        }
    }
    
}
