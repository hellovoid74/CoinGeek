//
//  Crypto.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 01/02/2022.
//

import Foundation
import RealmSwift

public class CryptoManager {
    
    var array: [CoinData] = []
    
    let assets = Constants.assets
    
    //MARK: Main decode method CoinApi
    
    func fetchData() {
        
        let str = "https://rest.coinapi.io/v1/assets/\(assets)"
        
        guard let url = URL(string: str) else {
            print("No such url!")
            return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.setValue(
            "A5BB84A6-B3C8-4B26-B7A8-89F5E0BCD0CF",
            forHTTPHeaderField: "X-CoinAPI-Key"
        )
        
        let session = URLSession.shared
        let _ = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print(String(describing: error))
            }
            else {
                
                if (response as? HTTPURLResponse) != nil {
                    //  print("Response is \(String(describing: response))")
                }
                
                guard let data = data else {return}
                
                let decoder = JSONDecoder()
                
                do {
                    let results = try decoder.decode([CoinData].self, from: data)
                    
                    self.array = results.filter {$0.type_is_crypto == 1 && $0.price_usd != nil}
        
                    results.filter {$0.type_is_crypto == 1 && $0.price_usd != nil}.forEach {
                        
                        guard let id = $0.asset_id else {return}
                        guard let name = $0.name else {return}
                        
                        let price = $0.price_usd
                        
                        self.array.append($0)
                        
                        self.saveData(id: id, name: name, price: price ?? 0)
                        
                    }
                    
                } catch {
                    print(String(describing: error))
                }
                
                
            }
        }.resume()
        
       
    }
    
    //MARK: - Save to realm
    
    func saveData(id: String, name: String, price: Float) {
        DispatchQueue.global().async {
            
            let realm = try! Realm()
            
            let coin = CoinObjects()
            
            do {
                try realm.write {
                    coin.id = id
                    coin.name = name
                    coin.price = price
                    
                    realm.add(coin)
                }
            } catch {
                print(String(describing: error))
            }
        }
    }
    
    
    
    //MARK: - Remove old data
    
    func removeOldData() {
        
        let realm = try! Realm()
        do {
            try realm.write {
                
                realm.delete(realm.objects(LogoObjects.self))
                realm.delete(realm.objects(CoinObjects.self))
            }
        } catch {
            print(String(describing: error))
        }
    }
    
    
    //MARK: - parsing exchange rates
    
    func parceRates(id: String) {
        
        let currentDate = Date()
        
       // let apiKey = "A5BB84A6-B3C8-4B26-B7A8-89F5E0BCD0CF"
        
       // let urlStr = "https://rest.coinapi.io/v1/exchangerate/\(id)/USD?time=2021-01-15T00:00:00"
        
        let urlStr = "https://api.coingecko.com/api/v3/coins/\(id)/history?date=01-01-2019&localization=en"
        
        guard let url = URL(string: urlStr) else {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
//        request.setValue(
//            apiKey,
//            forHTTPHeaderField: "X-CoinAPI-Key")
//        
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                print(String(describing: error))
            }
            
            guard let data = data else {return}
            let decoder = JSONDecoder()
            //decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let result = try decoder.decode(CoinGecko.self, from: data)
                print(result.market_data?.current_price["usd"])
            } catch {
                print(String(describing: error))
            }
            
        }.resume()
        
    }
   
}
