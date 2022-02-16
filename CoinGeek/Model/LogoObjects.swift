//
//  LogoObjects.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 03/02/2022.
//

import Foundation
import RealmSwift

class LogoObjects: Object {
    @Persisted var id: String
    @Persisted var url: String
    @Persisted var logo: Data
}
