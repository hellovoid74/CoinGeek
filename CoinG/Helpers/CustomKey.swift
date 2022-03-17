//
//  CustomKey.swift
//  CoinG
//
//  Created by Gleb Lanin on 16/03/2022.
//

import Foundation

final class CustomKey : NSObject {

    let string: String
    
    init(string: String) {
        self.string = string
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? CustomKey else {
            return false
        }
        return string == other.string
    }
    
    override var hash: Int {
        return string.hashValue
    }
}
