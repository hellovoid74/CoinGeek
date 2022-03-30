
//  Crypto.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 01/02/2022.
//
import Foundation

protocol DetailDelegate {
    func didUpdateData(_ manager: CryptoManager, detail: DetailModel, for periodIndex: Int)
}

public class CryptoManager {
    
    var delegate: DetailDelegate?
    private let dataRepository = DataRepository()
    private weak var task: URLSessionTask?
    var currency: String?
    
    
    //MARK: - parsing rates for SearchViewController
    
    func performRequests(for currency: String = "usd") {
        
        let firstUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=\(currency)&order=market_cap_desc&per_page=500&page=1&sparkline=false"
        fetchData(firstUrl)
    }
    
    func performSecondRequests(for currency: String = "usd") {
        let secondUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=\(currency)&order=market_cap_desc&per_page=500&page=2&sparkline=false"
        fetchData(secondUrl)
    }
    
    func fetchData(_ str: String) {
        
        guard let url = URL(string: str) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) {[weak self] (data, _, error) in
            if error != nil {
                print(String(describing: error))
            }
            else {
                guard let data = data else {return}
                let decoder = JSONDecoder()
                do {
                    let results = try decoder.decode([CoinData].self, from: data)
                    
                    DispatchQueue.global().async {
                        results.sorted(by: {$0.market_cap_rank < $1.market_cap_rank}).forEach {
                            
                            if let createdObject = self?.dataRepository.loadObjects().filter("id=%@", $0.id).first{
                                self?.dataRepository.updateObject(createdObject, with: ["price": $0.current_price, "change24h": $0.price_change_percentage_24h, "position": $0.market_cap_rank])
                            }
                            else {
                                let object = CoinObject(id: $0.id, name: $0.name, symbol: $0.symbol, price: $0.current_price, change24: $0.price_change_percentage_24h ?? 0, position: $0.market_cap_rank, url: $0.image ?? "")
                                self?.dataRepository.createObject(object)
                            }
                        }
                    }
                } catch {
                    print(String(describing: error))
                }
            }
        }
        
        task.resume()
        
        self.task = task
    }
    
    func cancelTask() {
        task?.cancel()
        print("cancelled")
    }
    
    //MARK: - parse coin information for DetailViewController
    
    func fetchDetails(_ id: String, _ index: Int = 0) {
        let str = "https://api.coingecko.com/api/v3/coins/\(id)"
        
        guard let url = URL(string: str) else {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let _ = session.dataTask(with: request) {[weak self] (data, _, error) in
            if error != nil {
                print(String(describing: error))
                return
            }
            else {
                
                guard let data = data else {return}
                
                let decoder = JSONDecoder()
                
                DispatchQueue.main.async {
                    
                    do {
                        let results = try decoder.decode(DetailData.self, from: data)
                        let id = results.id
                        
                        var text = String()
                        if let textData = results.description["en"] {
                            text = textData.count > 0 ? textData : "No information available"
                        } else {
                            text = "No information available"
                        }
                        
                        guard let price = results.market_data.current_price[self?.currency ?? "usd"] else {return}
                        guard let market = results.market_data.market_cap[self?.currency ?? "usd"] else {return}
                        var percentage = 0.0
                        
                        switch index{
                        case 1:
                            percentage = results.market_data.price_change_percentage_7d
                        case 2:
                            percentage = results.market_data.price_change_percentage_30d ?? 0
                        case 3:
                            percentage = results.market_data.price_change_percentage_1y ?? 0
                        default:
                            percentage = results.market_data.price_change_percentage_24h
                        }
                        
                        let model = DetailModel(detailId: id, info: text, price: price ?? 0, percentage: percentage, marketCap: market)
                        self?.delegate?.didUpdateData(self!, detail: model, for: index)
                        
                    } catch {
                        print(String(describing: error))
                    }
                }
            }
        }.resume()
    }
}


