//
//  Bundle+ParaingJSON.swift
//  Parsing-JSON-Using-Bundle
//
//  Created by Tiffany Obi on 8/3/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation
enum BundleError:Error {
    case invalidResource(String)
    case noContents(String)
    case decodingError(Error)
}

extension Bundle {
    //1.get the path of the file to be read using the bundle class
    //2. using the bath, read its data contents
    
    //Bundle.main is a singleton
    
    
    //parseJSON will be a throwing function
    //to use throwing functions you have to use try? or do{} catch{} or try!
    
    func parseJSON(with name:String) throws -> [President]{
        guard let path = Bundle.main.path(forResource: name, ofType: ".json") else { throw BundleError.invalidResource(name) }
        
        guard let data = FileManager.default.contents(atPath: path) else {
            throw BundleError.noContents(path)
        }
        
        var presidents: [President]
        
        do {
            presidents = try JSONDecoder().decode([President].self, from: data)
        } catch {
            throw BundleError.decodingError(error)
        }
        
        return presidents
    }
}
