//
//  LogoSaver.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 06/02/2022.
//

import Foundation
import RealmSwift

class LogoSaver {
    
    let realm = try! Realm()
    
    //MARK: - Logo saving method
    
    func getLogos() {
        
        let apikey = "B4DD390A-AAF0-4DD0-975E-41581F73F66D"
        let str = "https://rest.coinapi.io/v1/assets/icons/32?apikey=\(apikey)"
        
        guard let url = URL(string: str) else {
            print("No such url")
            return}
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            if error != nil {
                print(String(describing: error))
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode([LogoData].self, from: data)
                
                    let fetched = result.filter {Constants.assets.contains($0.asset_id)}
                    
                   // print(result.self)
                    fetched.forEach {
                        let id = $0.asset_id
                        let url = $0.url
                        self.saveLogo(id: id, url: url)
                    }
                    
                } catch {
                    print(String(describing: error))
                }
                
            }
        }.resume()
    }
    
    
    func saveLogo(id: String, url: String) {
        DispatchQueue.main.async { [self] in
            
            let logo = LogoObjects()
        
            do {
                try self.realm.write {
                    logo.id = id
                    logo.url = url
                    self.realm.add(logo)
                }
            } catch {
                print(String(describing: error))
            }
            
                        //print(logo.url)
            self.saveImg(strUrl: logo.url, obj: logo)
        }
    }
    
    
    func saveImg(strUrl: String, obj: LogoObjects) {
        
            guard let url = URL(string: strUrl) else {return}
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(String(describing: error))
                }
                DispatchQueue.main.async {
                do {
               let data = try Data(contentsOf: url)
                    
                        do {
                            try self.realm.write {
                                obj.logo = data
                            }
                        } catch {
                            print(String(describing: error))
                        }
                    
                } catch {
                    print(String(describing: error))
                }
                }
            }.resume()
    }

}
