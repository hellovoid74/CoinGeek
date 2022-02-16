//
//  CoinGecko.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 15/02/2022.
//

import Foundation
import SwiftUI

struct CoinGecko: Decodable {
    let id: String?
    let symbol: String?
    let name: String?
    let localization: Localization?
    let image: Image?
    let market_data: MarketData?
    let community_data: CommunityData?
    let developer_data: DeveloperData?
    let public_interest_stats: PublicInterests?
}


struct Localization: Decodable {
    
}

struct Image: Decodable {
    
}

struct MarketData: Decodable {
    let current_price: [String: Double]
    
}

struct CommunityData: Decodable {
    
}

struct DeveloperData: Decodable {
    
}

struct PublicInterests: Decodable {
    
}
