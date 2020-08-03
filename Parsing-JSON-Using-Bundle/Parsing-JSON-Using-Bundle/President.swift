//
//  President.swift
//  Parsing-JSON-Using-Bundle
//
//  Created by Tiffany Obi on 8/3/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation

struct President: Decodable,Hashable {
    let number: Int
    let name: String // formally president
    let birthYear: Int // formally birth_year
    let deathYear: Int? //death_year
    let tookOffice: String // took_office
    let leftOffice:String? // left_office
    let party:String

    
    private enum CodingKeys:String,CodingKey {
        case number
        case name = "president"
        case birthYear = "birth_year"
        case deathYear = "death_year"
        case tookOffice = "took_office"
        case leftOffice = "left_office"
        case party 
    }
}
