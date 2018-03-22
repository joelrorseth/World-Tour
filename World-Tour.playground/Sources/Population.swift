import Foundation

public class Population {
    
    // A population is a collection of genetic samples
    // For our purposes, a population is essentially a collection of Tours
    var tours = [Tour]()
    
    var sumFitnessAllTours: Double {
        return tours.reduce(0.0, { $0 + ($1).fitness })
    }
    
    
    // Default initialization generates random population (random Tour sequences)
    public init(size: UInt, startCity: City, cities: [City]) {
        
        generateTours(size: size, start: startCity, cities: cities)
    }
    
    // Generate a population of random genetic sequences (Tours)
    public func generateTours(size: UInt, start: City, cities: [City]) {
        
        // Generate 'size' random city sequences to populate the population
        for _ in 0 ..< size {
            tours.append(Tour(start: start, cities: cities, random: true))
        }
    }
}
