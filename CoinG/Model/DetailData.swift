//
//  DetailData.swift
//  CoinG
//
//  Created by Gleb Lanin on 13/03/2022.
//

import Foundation

struct DetailData: Codable{
    let id: String
    let symbol: String
    let name: String
    let description: [String: String]
    let image: [String: String?]
    let country_origin: String?
    let genesis_date: String?
    let market_cap_rank: Int
    let market_data: MarketData
}

struct MarketData: Codable{
    let current_price: [String: Double?]
    let market_cap: [String: Int]
    let market_cap_rank: Int?
    let total_volume: [String: Double]
    let price_change_percentage_24h: Double
    let price_change_percentage_7d: Double
    let price_change_percentage_30d: Double?
    let price_change_percentage_1y: Double?
}
