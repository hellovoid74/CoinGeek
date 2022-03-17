//
//  CoinData.swift
//  CoinG
//
//  Created by Gleb Lanin on 12/03/2022.
//

import Foundation

struct CoinData: Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: String?
    let current_price: Double
    let market_cap: Double
    let market_cap_rank: Int
    let price_change_percentage_24h: Double?
    let roi: Roi?
}

struct Roi: Decodable {
    
}

