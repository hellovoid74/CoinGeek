
//  DataRepository.swift
//  CoinG
//
//  Created by Gleb Lanin on 19/02/2022.
//
import Foundation
import RealmSwift

class DataRepository {
    
    let realm = try! Realm()
    
    //MARK: - Print realm location
    
    func printLocation(){
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    //MARK: - Create object
    
    func createObject<T: Object>(_ object: T){
        let frealm = try! Realm()
        do {
            try frealm.write{
                frealm.add(object)
            }
        } catch {
            print(String(describing: error))
        }
    }
    
    //MARK: - Update object
    
    func updateObject<T: Object>(_ object: T, with dictionary: [String: Any?]){
        let frealm = try! Realm()
        do {
            try frealm.write{
                for (key, value) in dictionary{
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            print(String(describing: error))
        }
    }
    
    //MARK: - Load data from realm
    
    func loadObjects() -> Results<CoinObject>{
        let frealm = try! Realm()
        return frealm.objects(CoinObject.self).sorted(byKeyPath: "position", ascending: true)
    }
    
    func loadFavouriteObjects() -> Results<CoinObject>{
        let frealm = try! Realm()
        return frealm.objects(CoinObject.self).filter("bookmarked == true").sorted(byKeyPath: "timeCreated", ascending: true)
    }
    
    func loadTopobjects() -> Results<CoinObject>{
        let frealm = try! Realm()
        return frealm.objects(CoinObject.self).filter("position < 26").sorted(byKeyPath: "position", ascending: true)
    }
    
  
    //MARK: - Remove old data
    
    func removeOldData(){
        let frealm = try! Realm()
        do {
            try frealm.write {
                frealm.delete(frealm.objects(CoinObject.self))
            }
        } catch {
            print(String(describing: error))
        }
    }
    
}
