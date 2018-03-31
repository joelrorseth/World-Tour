import Foundation

public struct GeneticParameters {
    
    var populationSize: Int!
    var numberOfGenerations: Int!
    var mutationRate: Double!
    
    public init(populationSize: Int, numberOfGenerations: Int, mutationRate: Double) {
        
        self.populationSize = populationSize
        self.numberOfGenerations = numberOfGenerations
        self.mutationRate = mutationRate
    }
}
