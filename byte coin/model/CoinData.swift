//
//  CoinData.swift
//  byte coin
//
//  Created by Harsh  on 22/07/21.
//

import Foundation

struct CoinData:Codable{
    let time:String
    let asset_id_base:String
    let asset_id_quote:String
    let rate:Double
}
