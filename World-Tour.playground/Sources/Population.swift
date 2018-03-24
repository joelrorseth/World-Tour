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
    
    // Custom initializer directly sets the generation of the population with new Tour objects
    // Use this initializer to replace the population with new generation of better Tours
    public init(tours: [Tour]) {
        
        self.tours = tours
    }
    
    // Generate a population of random genetic sequences (Tours)
    public func generateTours(size: UInt, start: City, cities: [City]) {
        
        // Generate 'size' random city sequences to populate the population
        for _ in 0 ..< size {
            tours.append(Tour(start: start, cities: cities, random: true))
        }
    }
    
    public func rankToursByFitness() -> [Double] {
        
        // Sort the Tour objects of the current population by decreasing fitness
        tours.sort(by: { $0.fitness > $1.fitness })
        
        let sumFitness: Double = sumFitnessAllTours / Double(tours.count)
        
        // Return array of propabilities (based on fitness) of selecting a Tour at a given index
        // The fitnesses are use to weight the probability for a Tour at given index vs others
        return tours.map({ $0.fitness / sumFitness })
    }
}
