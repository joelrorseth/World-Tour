import Foundation
import QuartzCore

public class PnPGeneticAlgorithm {
    
    var currentPopulation: Population!
    var startCity: City!
    var populationSize: Int!
    var tourSize: Int!
    var mutationRate: Double!
    var numberOfGenerations: Int
    
    // Functions defined elsewhere
    var selection: ((Population, Double) -> Tour)
    var crossover: ((Tour, Tour) -> Tour)
    
    // A delegate will recieve simulation updates in real-time
    public var simulationDelegate: SimulationDelegate?
    
    
    public init(parameters: PnPGeneticParameters, startCity: City, cities: [City]) {
        
        self.startCity = startCity
        self.populationSize = parameters.populationSize
        self.tourSize = cities.count
        self.mutationRate = parameters.mutationRate
        self.numberOfGenerations = parameters.numberOfGenerations
        
        self.selection = parameters.selection
        self.crossover = parameters.crossover
        
        // Generate a single population for the genetic algorithm to evolve
        currentPopulation = Population(size: parameters.populationSize,
                                       startCity: startCity, cities: cities)
    }
    
    
    // Simulate the evolution of 'n' generations
    public func simulateNGenerations() -> Tour? {
        
        // Share info about random initial generation
        reportNewGeneration(generation: 0)
        
        // Run Genetic Algorithm across 'n' generations
        for gen in 1...numberOfGenerations {
            
            var nextGeneration = [Tour]()

            // For each new member of population
            for _ in 0..<populationSize {
                
                // Obtain total distance over all tours in population -- total population distance
                let populationTotalDistance = currentPopulation.totalDistanceOverAllTours()

                // Choose two parents randomly, favouring the fit
                // This PnP function is defined by user in playground
                let parentOne = selection(currentPopulation, populationTotalDistance)
                let parentTwo = selection(currentPopulation, populationTotalDistance)
                
                // Parents produce a single offspring
                // This PnP function is also defined in playground
                var childTour = crossover(parentOne, parentTwo)

                // Randomly apply a mutation to the new Tour
                mutate(tour: &childTour)

                // Add tour to next generation
                nextGeneration.append(childTour)
            }
            
            // Establish new population / generation of Tours
            currentPopulation = Population(tours: nextGeneration)
            reportNewGeneration(generation: gen)
        }
        
        return currentPopulation.getFittest()
    }
    
    
    // Return the score of the best Tour sequence in the current population
    public func distanceForBestTour() -> Double? {

        return currentPopulation.getFittest()?.totalDistance
    }
    
    
    // Mutation function will randomly apply a single mutation
    // In travelling salesman, this means we randomly swap position of two cities in Tour
    private func mutate(tour: inout Tour) {
        
        // Generate random number [0,100)
        let rate = Double(arc4random_uniform(101)) / 100.0
        
        // With probability = mutationRate, swap the city at index i with a random index j
        if (rate < mutationRate) {
            
            // Get another random position to swap City objects
            let i: Int = Int(arc4random_uniform(UInt32(tourSize)))
            let j: Int = Int(arc4random_uniform(UInt32(tourSize)))
            
            // Perform the random mutation by swapping the cities
            tour.cities.swapAt(i, j)
        }
    }
    
    // Issue updates regarding the new generation
    public func reportNewGeneration(generation: Int) {
        
        // On main thread, signal to delegate to draw the path by calling this protocol method
        if let delegate = self.simulationDelegate,
            let fittest = self.currentPopulation.getFittest() {
            delegate.yieldNewGeneration(fittest: fittest)
        }
        
        // Print to console
        if let distance = distanceForBestTour() {
            print("Generation \(generation): Total distance = \(distance)")
        }
    }
}


// Define protocol in which delegate will recieve updtes on simulation progress
public protocol SimulationDelegate {

    func yieldNewGeneration(fittest: Tour)
}

