import Foundation

public struct PnPGeneticParameters {
    
    var populationSize: Int!
    var numberOfGenerations: Int!
    var mutationRate: Double!
    
    var selection: ((Population, Double) -> Tour)
    var crossover: ((Tour, Tour) -> Tour)
    var mutation: ((Tour, Double) -> Tour)
    
    public init(populationSize: Int, numberOfGenerations: Int, mutationRate: Double,
                selection: @escaping ((Population, Double) -> Tour),
                crossover: @escaping ((Tour, Tour) -> Tour),
                mutation: @escaping ((Tour, Double) -> Tour)) {
        
        self.populationSize = populationSize
        self.numberOfGenerations = numberOfGenerations
        self.mutationRate = mutationRate
        
        self.selection = selection
        self.crossover = crossover
        self.mutation = mutation
    }
}
