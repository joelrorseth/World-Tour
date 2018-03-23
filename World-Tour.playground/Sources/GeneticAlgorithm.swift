import Foundation

public class GeneticAlgorithm {
    
    var population: Population!
    var populationSize: UInt = 0
    
    public init(populationSize: UInt, startCity: City, cities: [City]) {
        
        // Generate a single population for the genetic algorithm to evolve
        population = Population(size: populationSize,
            startCity: startCity, cities: cities)
        
        self.populationSize = populationSize
    }
    
    public func simulateNGenerations() {
        
    }
    
    public func createGeneration() {
        
    }
    
    private func selection() {
        
        // Determine the normalized fitness percentage for each tour
        let fitnessProbabilities = population.rankToursByFitness()
        
        // We will seek pairs of Tours that will, together, generate the next generation
        var newGenerationPairs = [(tour1: Tour, tour2: Tour)]()
        
        // Generate enough pairs to replace the current generation
        for _ in 0 ..< (populationSize / 2) {
         
            // Draw populationSize/2 pairs of Tours, where Tour likelihood determined by fitness
            let (index1, index2) = twoFitIndicesFrom(probDist: fitnessProbabilities)
            
            newGenerationPairs.append((
                tour1: population.tours[index1],
                tour2: population.tours[index2]
            ))
        }
    }
    
    
    // Determine two random indicies, selected according to prob. dist. given by index in passed array
    private func twoFitIndicesFrom(probDist: [Double]) -> (index1: Int, index2: Int) {
            
        // TODO: Error checking -- There should never be fewer than two Tours
        
        var probDist = probDist
        
        let index1 = randomFitIndexFrom(probDist: probDist)
        
        // Make it impossible (probability = 0) to select the same index again
        probDist[index1] = 0.0
        
        let index2 = randomFitIndexFrom(probDist: probDist)
        
        return (index1, index2)
    }
    
    // Determine a random index, with prob. for index determined by value at the index in passed array
    private func randomFitIndexFrom(probDist: [Double]) -> Int {
        
        // Calculate total probability, this should be approx 1.0
        let sum = probDist.reduce(0, +)
        
        // Random number drawn from normal dist -- essentially in [0, 1] or [0, sum]
        let rand = sum * Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
        
        // Find first interval which rand falls into
        var running = 0.0
        for (i, p) in probDist.enumerated() {
            running += p
            if rand < running { return i }
        }
        
        return (probDist.count - 1)
    }
    
    
    private func crossover() {
        
    }
    
    private func mutation() {
        
    }
}
