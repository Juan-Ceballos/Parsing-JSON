//
//  Station.swift
//  Parsing_JSON_Using_URLSession
//
//  Created by Juan Ceballos on 8/4/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import Foundation

struct ResultsWrapper: Decodable {
    let data: StationsWrapper
}

struct StationsWrapper: Decodable {
    let stations: [Station]
}

struct Station: Decodable, Hashable {
    let name: String
    let stationType: String
    let lat: Double
    let lon: Double
    let capacity: Int
    
    private enum CodingKeys: String, CodingKey {
        case name
        case stationType = "station_type"
        case lat
        case lon
        case capacity
    }
}
