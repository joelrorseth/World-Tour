import Foundation
import QuartzCore

public class GeneticAlgorithm {
    
    let pointsToKmFactor = 3.3
    
    var currentPopulation: Population!
    var startCity: City!
    var populationSize: Int!
    var tourSize: Int!
    var mutationRate: Double!
    
    // A delegate will recieve simulation updates in real-time
    var simulationDelegate: SimulationDelegate?
    
    
    public init(parameters: GeneticParameters, startCity: City, cities: [City]) {
        
        self.startCity = startCity
        self.populationSize = parameters.populationSize
        self.tourSize = cities.count
        self.mutationRate = parameters.mutationRate

        // Generate a single population for the genetic algorithm to evolve
        currentPopulation = Population(size: parameters.populationSize,
            startCity: startCity, cities: cities)
    }

    
    // Simulate the evolution of 'n' generations
    public func simulateNGenerations(n: Int) -> Tour? {
        reportNewGeneration(generation: 0)
        
        // Run Genetic Algorithm across 'n' generations
        for gen in 1 ... n {
            
            var nextGeneration = [Tour]()

            for p in 0..<populationSize {
                
                // Obtain total distance over all tours in population -- total population distance
                let populationTotalDistance = currentPopulation.totalDistanceOverAllTours()
                
                // Choose two parents randomly, favouring the fit
                let parentOne = selectParent(populationDistance: populationTotalDistance)
                let parentTwo = selectParent(populationDistance: populationTotalDistance)

                // Parents produce a single offspring
                var childTour = produceOffspring(
                    firstParent: parentOne, secondParent:parentTwo)
                
                // Randomly apply a mutation to the new Tour
                mutate(tour: &childTour)
                
                // Add tour to next generation
                nextGeneration.append(childTour)
            }
            
            // Establish new population / generation of Tours
            currentPopulation = Population(tours: nextGeneration)
            reportNewGeneration(generation: gen)
        }
        
        reportSimulationFinished()
        return currentPopulation.getFittest()
    }
    
    
    // Return the score of the best Tour sequence in the current population
    public func distanceForBestTour() -> Double? {

        return currentPopulation.getFittest()?.totalDistance
    }
    
    
    // Select a single Tour, with likelihood increasing proportional to fitness within population
    private func selectParent(populationDistance: Double) -> Tour {

        // Generate random number in [0,1]
        let fitness = Double(arc4random()) / Double(UINT32_MAX)
        
        var currentFitness: Double = 0.0
        var result: Tour!
        
        // Probability of Tour being selected as parent is equal to its fitness proportional to others in population
        currentPopulation.tours.forEach { (tour) in
            if currentFitness <= fitness {
                
                // Increase probability threshold and set this tour as current selection
                currentFitness += tour.fitness(withPopulationDistance: populationDistance)
                result = tour
            }
        }
        
        return result
    }
    
    
    // Produce an offspring Tour for two Tours
    private func produceOffspring(firstParent: Tour, secondParent: Tour) -> Tour {
        
        let slice: Int = Int(arc4random_uniform(UInt32(firstParent.cities.count)))
        var cities: [City] = Array(firstParent.cities[0..<slice])
        
        var idx = slice
        while cities.count < secondParent.cities.count {
            let city = secondParent.cities[idx]
            if cities.contains(city) == false {
                cities.append(city)
            }
            idx = (idx + 1) % secondParent.cities.count
        }
        
        return Tour(start: startCity, cities: cities)
    }
    
    
    // Implementation of the Ordered Crossover (OX) crossover operator proposed by Davis
    // This method didn't yeild as optimal results
    /*
    private func crossoverOX(pairs: [(tour1: Tour, tour2: Tour)]) -> [Tour] {
        
        // TODO: Error checking -- All Tours should be same size, include the same locations
        
        var newTours = [Tour]()
        
        for (t1, t2) in pairs {
            
            let n1 = Int(arc4random_uniform(UInt32(tourSize - 1)))
            let n2 = Int(arc4random_uniform(UInt32(tourSize)))
            
            let start = min(n1, n2)
            let end = max(n1, n2)
            
            var c1 = Array(t1.cities[start..<end])
            var c2 = Array(t2.cities[start..<end])
            
            var currentCityIndex = 0
            var currentCityInT1 = City(name: "", lat: -1, lng: -1)
            var currentCityInT2 = City(name: "", lat: -1, lng: -1)
            
            for i in 0..<tourSize {
                
                currentCityIndex = (end + i) % tourSize
                
                // get the city at the current index in each of the two parent tours
                currentCityInT1 = t1.cities[currentCityIndex]
                currentCityInT2 = t2.cities[currentCityIndex]
                
                
                // if child 1 does not already contain the current city in tour 2, add it
                if (!c1.contains(currentCityInT2)) {
                    c1.append(currentCityInT2)
                }
                
                // if child 2 does not already contain the current city in tour 1, add it
                if (!c2.contains(currentCityInT1)) {
                    c2.append(currentCityInT1)
                }
            }

            // rotate the lists so the original slice is in the same place as in the
            c1.shiftRightInPlace(amount: start)
            c2.shiftRightInPlace(amount: start)
            
            // copy the tours from the children back into the parents
            newTours.append(Tour(start: startCity, cities: c1))
            newTours.append(Tour(start: startCity, cities: c2))
        }
        
        return newTours
    }
    */
    
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
        
        // Print to console
        if let distance = distanceForBestTour() {
            print("Generation \(generation): Best distance = \(distance*pointsToKmFactor) km")
        }
    }
    
    // Issue update regarding simulation finishing
    public func reportSimulationFinished() {
        
        // Signal to delegate to draw the path by calling this protocol method
        if let delegate = self.simulationDelegate,
            let fittest = self.currentPopulation.getFittest() {
            delegate.yieldNewGeneration(fittest: fittest)
        }
    }
}
