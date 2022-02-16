//
//  CoinData.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 03/02/2022.
//

import Foundation

struct Root: Decodable {
    let coins: [CoinData]
}

struct CoinData: Decodable {
    let asset_id: String?
    let name: String?
    let type_is_crypto: Int?
    let data_quote_start: String?
    let data_quote_end: String?
    let data_orderbook_start: String?
    let data_orderbook_end: String?
    let data_trade_start: String?
    let data_trade_end: String?
    let data_symbols_count: Double?
    let volume_1hrs_usd: Double?
    let volume_1day_usd: Double?
    let volume_1mth_usd: Double?
   // let id_icon: String?
    let data_start: String?
    let data_end: String?
    let price_usd: Float?
    let time_period_start: Int?
   // let icon: Data?
}
//
//{
//  "asset_id": "BTC",
//  "name": "Bitcoin",
//  "type_is_crypto": 1,
//  "data_start": "2010-07-17",
//  "data_end": "2019-11-03",
//  "data_quote_start": "2014-02-24T17:43:05.0000000Z",
//  "data_quote_end": "2019-11-03T17:55:07.6724523Z",
//  "data_orderbook_start": "2014-02-24T17:43:05.0000000Z",
//  "data_orderbook_end": "2019-11-03T17:55:17.8592413Z",
//  "data_trade_start": "2010-07-17T23:09:17.0000000Z",
//  "data_trade_end": "2019-11-03T17:55:11.8220000Z",
//  "data_symbols_count": 22711,
//  "volume_1hrs_usd": 102894431436.49,
//  "volume_1day_usd": 2086392323256.16,
//  "volume_1mth_usd": 57929168359984.54,
//  "price_usd": 9166.207274778093436220194944
//}
//

//JSON data for another method from CryptoManager
//struct CryptoData: Codable {
//
//    let currency: String
//    let rate: String
//    let timestamp: String
//}
//


