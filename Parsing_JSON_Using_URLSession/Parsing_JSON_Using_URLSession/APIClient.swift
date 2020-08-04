//
//  APIClient.swift
//  Parsing_JSON_Using_URLSession
//
//  Created by Tiffany Obi on 8/4/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation
import Combine
//todo: convert to a generic type
// conform the apiclent to decodable

enum  AppError:Error  {
    case badURL(String)
    case networkError(Error)
    case decodingError(Error)
}

class APIClient {
    
    //the fetch data bethod does an asynchronous network call
    //this means the method return (BEFORE) the request is complete
    // when dealing with asynchromous call we use a closure
    // other mechanisms you can use include : delegation, Notification/Center
    // newwer to us as of ios13 is Combine.
    
    //combine works with publishers and cubscribers
    //publoshers are values omitted overtime
    //subscribers receive values and can perform operations onn those values
    func fetchData() throws -> AnyPublisher<[Station], Error> {
     let endpoint = "https://gbfs.citibikenyc.com/gbfs/en/station_information.json"
     guard let url = URL(string: endpoint) else {
      throw AppError.badURL(endpoint)
     }
     return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data) //data, repsonse, error
      .decode(type: ResultsWrapper.self, decoder: JSONDecoder()) // ResultsWrapper
      .map{ $0.data.stations }
      .eraseToAnyPublisher()
    }
    
    func fetchData(completion:@escaping (Result<[Station],AppError>)-> ()){
        let endpoint = "https://gbfs.citibikenyc.com/gbfs/en/station_information.json"
        
        //1. we need a url to create out network request
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.badURL(endpoint)))
            return
        }
        
        // 2. create a Get request , other requests are Post,Delete,Patch,Put etc
        
        let request =  URLRequest(url: url)
        
        //user urlSession to make the network request
        
        //urlSession.shared is a singleton
        //this is sufficient to use for making most requests
        //using urlsession without the share instamce gives you access  to adding neccessary congifurations to your task
        let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error ) in
            if let error = error {
                completion(.failure(.networkError(error)))
            }
            if let data = data {
                //4. decode the json to our swift model
                
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
