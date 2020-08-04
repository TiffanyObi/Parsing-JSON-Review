//
//  Station.swift
//  Parsing_JSON_Using_URLSession
//
//  Created by Tiffany Obi on 8/4/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation


struct ResultsWrapper:Codable {
    let data: StationsWrapper
}

struct StationsWrapper:Codable {
    let stations : [Station]
}
struct Station: Codable,Hashable {
    let name:String
    let stationType:String
    let latitude:Double
    let longitude: Double
    let capacity: Int
    
    private enum CodingKeys: String, CodingKey {
        case name
        case stationType = "station_type"
        case latitude = "lat"
        case longitude = "lon"
        case capacity
    }
}
