//
//  CityFactory.swift
//  GeneticAlgorithm
//
//  Created by Joel Rorseth on 2018-03-28.
//  Copyright © 2018 Joel Rorseth. All rights reserved.
//

import Foundation
import SpriteKit

public class CityFactory {

    // Factory method to return array of all cities (read from JSON)
    public static func createCitiesFromJSON(number: Int) -> [City] {
        
        if let jsonFile = Bundle.main.url(forResource: "ca", withExtension: "json") {
            do {
                
                // Obtain Data object for JSON
                let data = try Data(contentsOf: jsonFile)
                
                // Decode JSON into array of City objects
                let decoder = JSONDecoder()
                let jsonCities = try decoder.decode([City].self, from: data)

                // Avoid too many cities being requested
                let number = (number > jsonCities.count) ? jsonCities.count : number
                
                // Return the first 'number' cities
                return Array(jsonCities[0..<number])
            
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        return [City]()
    }
    
    // Create array of City objects mapped from SKNodes
    public static func createCitiesFromNodes(nodes: [SKNode], parent: SKNode) -> [City] {
        
        var cities = [City]()
        
        for i in 0..<nodes.count {
            
            // Treate x and y position as latitude and longitude
            // Note: x,y coordinates are local to background node, must be transformed back
            
            
            cities.append(
                City(name: "P\(i+1)",
                     lat: Double(nodes[i].position.x),
                     lng: Double(nodes[i].position.y))
            )
        }
        
        return cities
    }
}
