//
//  Constants.swift
//  CoinG
//
//  Created by Gleb Lanin on 12/03/2022.
//

import Foundation
import UIKit

enum Constants{
    //text
    static let welcomeText = "Welcome To CoinGeek"
    static let markets = "Markets"
    static let descriptionText = "Your ultimate crypto helper"
    static let segmentedValues = ["All markets", "Favourites"]
    static let segmentedIntervals = ["1D","1W","1M","1Y"]
    static let marketCap = "Market cap.:"
    static let currencyKey = "Currency"
    
    //identifiers
    static let toListId = "toSearch"
    static let toCoinVC = "toCoinVC"
    
    static let currencySet = ["USD" ,"EUR", "GBP", "UAH", "AUD", "CAD", "CZK", "JPY", "PLN", "RUB", "SEK"]
    static let currencyDict = ["usd": "$","eur": "€", "gbp": "£", "uah": "₴", "aud": "$", "cad": "$", "czk": "Kč", "jpy": "¥", "pln": "zł" , "rub": "₽", "sek": "kr"]
            
    //images
    enum Images{
        static let triangleUp = UIImage(systemName: "arrowtriangle.up.fill")
        static let triangleDown = UIImage(systemName: "arrowtriangle.down.fill")
        static let heart = UIImage(systemName: "heart")
        static let heartFill = UIImage(systemName: "heart.fill")
        static let list = UIImage(systemName: "list.dash")
        static let dollar = UIImage(systemName: "dollarsign.square")
        static let globe = UIImage(systemName: "globe")
    }
}

