//
//  Parsing_JSON_Using_URLSessionTests.swift
//  Parsing_JSON_Using_URLSessionTests
//
//  Created by Juan Ceballos on 8/4/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import XCTest
@testable import Parsing_JSON_Using_URLSession

class Parsing_JSON_Using_URLSessionTests: XCTestCase {
    
    func testModel() {
        // arrange
        let jsonData = """
        {
            "data": {
                "stations": [{
                        "lat": 40.76727216,
                        "eightd_has_key_dispenser": false,
                        "station_id": "72",
                        "name": "W 52 St & 11 Ave",
                        "rental_methods": [
                            "CREDITCARD",
                            "KEY"
                        ],
                        "region_id": "71",
                        "legacy_id": "72",
                        "has_kiosk": true,
                        "lon": -73.99392888,
                        "short_name": "6926.01",
                        "capacity": 55,
                        "rental_url": "http://app.citibikenyc.com/S6Lr/IBV092JufD?station_id=72",
                        "external_id": "66db237e-0aca-11e7-82f6-3863bb44ef7c",
                        "station_type": "classic",
                        "electric_bike_surcharge_waiver": false,
                        "eightd_station_services": []
                    },
                    {
                        "lat": 40.71911552,
                        "eightd_has_key_dispenser": false,
                        "station_id": "79",
                        "name": "Franklin St & W Broadway",
                        "rental_methods": [
                            "CREDITCARD",
                            "KEY"
                        ],
                        "region_id": "71",
                        "legacy_id": "79",
                        "has_kiosk": true,
                        "lon": -74.00666661,
                        "short_name": "5430.08",
                        "capacity": 33,
                        "rental_url": "http://app.citibikenyc.com/S6Lr/IBV092JufD?station_id=79",
                        "external_id": "66db269c-0aca-11e7-82f6-3863bb44ef7c",
                        "station_type": "classic",
                        "electric_bike_surcharge_waiver": false,
                        "eightd_station_services": []
                    }
                ]
            }
        }
    """.data(using: .utf8)!
        
    let expectedCapacity = 85
        do {
            let results = try JSONDecoder().decode(ResultsWrapper.self, from: jsonData)
            let stations = results.data.stations
            let firstStation = stations[0]
            // assert
            XCTAssertEqual(expectedCapacity, firstStation.capacity)
        } catch {
            XCTFail("\(error)")
        }
        
    }
    
}
