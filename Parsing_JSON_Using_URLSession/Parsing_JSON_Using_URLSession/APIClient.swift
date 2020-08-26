//
//  APIClient.swift
//  Parsing_JSON_Using_URLSession
//
//  Created by Juan Ceballos on 8/4/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import Foundation
import Combine

// Combine rework

enum APIError: Error {
    case badURL(String)
    case networkError(Error)
    case decodingError(Error)
}

// TODO: convert to a Generic APIClient<Station>()
// conform APIClient to Decodable
class APIClient {
    
    // **Added for Combine**
    // Combine works with publishers and subscribers
    // publishers are values emitted over time
    // subscribers receive values and can perform operation on those values
    // some operations that can be performed map, filer, sort...
    func fetchData() throws -> AnyPublisher<[Station], Error>    {
        let endpoint = "https://gbfs.citibikenyc.com/gbfs/en/station_information.json"
        
        guard let url = URL(string: endpoint) else {
            throw APIError.badURL(endpoint)
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ResultsWrapper.self, decoder: JSONDecoder()) // ResultsWrapper to [Station]
            .map { $0.data.stations }
            .eraseToAnyPublisher()
    }
    
    // the fetchData() method does an asynchronous network call
    // this means the method returns (BEFORE) the request is complete
    
    // when dealing with asynchronous calls we use a closure,
    // closures captures values, it's a reference type
    func fetchData(completion: @escaping (Result<[Station], APIError>) -> ()) {
        let endpoint = "https://gbfs.citibikenyc.com/gbfs/en/station_information.json"
        // 1.
        // we need url to create our network request
        guard let url = URL(string: endpoint) else {
            completion(.failure(.badURL(endpoint)))
            return
        }
        
        // 2. create a Get request, other ex POST, DELETE, PUT
        let request = URLRequest(url: url)
        
        // 3. use URLSession to make a network request
        // URLSession.shared is a singleton
        // this is sufficient to use for making most request
        // Using URLSession without the shared instance gives you access
        // to adding necessary configurations to your task
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            if let data = data {
                // 4. decode json to our swift model
                do {
                    let results = try JSONDecoder().decode(ResultsWrapper.self, from: data)
                    completion(.success(results.data.stations))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        dataTask.resume()
    }
}
