
//  GraphManager.swift
//  CoinG
//
//  Created by Gleb Lanin on 12/03/2022.
//

import Foundation
import Charts

protocol ChartDelegate {
    func drawChart(_ manager: GraphManager, model: HistoryModel)
}

class GraphManager {
    var drawDelegate: ChartDelegate?
    private let dataRepository = DataRepository()
    
    func getHistoricalData(id: String, for timeIndex: Int = 0) {
        
        var timeRange: Double
        switch timeIndex{
        case 1:
            timeRange = 7
        case 2:
            timeRange = 30
        case 3:
            timeRange = 365
        default:
            timeRange = 1
        }

        let urlStr = "https://api.coingecko.com/api/v3/coins/\(id)/market_chart?vs_currency=usd&days=\(timeRange)"
        
        guard let url = URL(string: urlStr) else {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {[unowned self] (data, _, error) in
            if error != nil {
                print(String(describing: error))
                return
            }
            
            guard let data = data else {return}
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(HistoryData.self, from: data)
            
                var xCord = 0
                var array = [ChartDataEntry]()
     
                result.prices.forEach {
                    let yCord = $0[1]
                    let object = ChartDataEntry(x: Double(xCord), y: yCord)
                    xCord += 1
                    array.append(object)
                }
                            
                let obj = HistoryModel(coords: array)
                self.drawDelegate?.drawChart(self, model: obj)

            } catch {
                print(String(describing: error))
            }
        }.resume()
    }
}
