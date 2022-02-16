//
//  Helper.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 04/02/2022.
//

import Foundation


class Helper {
    
    let assets = Constants.assets
    
    
    //call Helper.parseJSONfromFile() to parse local query.json file and save all PNG icons consisted in assets string.
    
    func parseJSONfromFile() {
        
        guard let path = Bundle.main.path(forResource: "query", ofType: "json") else {return}
        
        let url = URL(fileURLWithPath: path)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(String(describing: error))
                return
            }
            
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let output = try decoder.decode([LogoData].self, from: data)
                
                let filtered = output.filter {self.assets.contains($0.asset_id)}
               
                for element in filtered {
                   let id = element.asset_id
                    let strUrl = element.url
                    guard let url = URL(string: strUrl) else {return}
                    let data = try? Data(contentsOf: url)
                    let imageName = self.getDocumentsDirectory().appendingPathComponent("\(id).png")
                    
                    guard let data = data else {return}
                    try data.write(to: imageName)
    
                }
            }
            catch {
                print(String(describing: error))
            }
        }.resume()
    }
    
    
    //detect local path
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}
