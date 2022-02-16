//
//  ExchangeData.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 06/02/2022.
//

import Foundation

struct ExchangeData: Decodable {
    let rates: [Rate]
}

struct Rate: Decodable {
    let time_period_start: String?
    let time_period_end: String?
    let time_open: String?
    let time_close: String?
    let rate_open: Double?
    let rate_high: Double?
    let rate_low: Double?
    let rate_close: Double?
   // let trades_count: Int
 //   let volume_traded: Double

}

struct certainRate: Decodable {
    
    let time: String?
    let id: String
    let quote: String
    let rate: Double
    
    enum CodingKeys: String, CodingKey {
        case time = "time"
        case id = "asset_id_base"
        case quote = "asset_id_quote"
        case rate = "rate"
    }
    }


struct srdcBase: Decodable {
    let time: String
    let asset: String
    let rate: Double
    let volume: Double
}
