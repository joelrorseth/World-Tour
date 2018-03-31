import Foundation

public struct GeneticParameters {
    
    var populationSize: Int!
    var numberOfGenerations: Int!
    var mutationRate: Double!
    
    var selection: ((Population) -> Tour)
    var crossover: ((Tour, Tour) -> Tour)
    
    public init(populationSize: Int, numberOfGenerations: Int, mutationRate: Double,
                selection: @escaping ((Population) -> Tour), 
                crossover: @escaping ((Tour, Tour) -> Tour)) {
        
        self.populationSize = populationSize
        self.numberOfGenerations = numberOfGenerations
        self.mutationRate = mutationRate
        
        self.selection = selection
        self.crossover = crossover
    }
}
