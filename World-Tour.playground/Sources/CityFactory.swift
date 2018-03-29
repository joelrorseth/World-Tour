//
//  CityFactory.swift
//  GeneticAlgorithm
//
//  Created by Joel Rorseth on 2018-03-28.
//  Copyright © 2018 Joel Rorseth. All rights reserved.
//

import Foundation

public class CityFactory {

    // Factory method to return array of cities read from JSON
    public static func createCitiesFromJSON() -> [City] {

        if let jsonFile = Bundle.main.url(forResource: "ca", withExtension: "json") {
            do {
                
                // Obtain Data object for JSON
                let data = try Data(contentsOf: jsonFile)
                
                // Decode JSON into array of City objects
                let decoder = JSONDecoder()
                let jsonCities = try decoder.decode([City].self, from: data)

                return jsonCities
            
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        return [City]()
    }
}
