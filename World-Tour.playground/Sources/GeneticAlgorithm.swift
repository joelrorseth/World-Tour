import Foundation

public class GeneticAlgorithm {
    
    var population: Population!
    var startCity: City!
    var populationSize: Int = 0
    var tourSize: Int = 0
    var mutationRate = 0.5
    
    public init(populationSize: Int, mutationRate: Double, startCity: City, cities: [City]) {
        
        // Generate a single population for the genetic algorithm to evolve
        population = Population(size: populationSize,
            startCity: startCity, cities: cities)
        
        self.startCity = startCity
        self.populationSize = populationSize
        self.tourSize = cities.count
        self.mutationRate = mutationRate
    }
    
    /*
 
     for tour in newTours {
     if Set(tour.cities).count != 8 {
     print(tour.cities)
     }
     }
     
 */
    
    public func simulateNGenerations(n: Int) {
        
        print("Starting fitness:")
        bestTourInCurrentPopulation()
        
        print(" ")
        
        for i in 0 ..< n {
            
            // Get new pairs for CURRENT population using the selection algorithm
            let newSelectionPairs = selection()

            
            // Perform crossover to obtain next generation of Tour objects (in next population)
            var newTours = crossover(pairs: newSelectionPairs)
            
            // Randomly mutate these new tours before establishing them as new population
            for tourIndex in 0 ..< newTours.count {
                mutate(tour: &newTours[tourIndex])
            }
            
            // Reset population to be the next generation
            self.population = Population(tours: newTours)
            bestTourScore(genNumber: i)
        
        }
        
        bestTourInCurrentPopulation()
    }
    
    public func bestTourScore(genNumber: Int) {
        
        if let fittest = population.getFittest() {
            
            print("Generation \(genNumber) score: \(fittest.totalDistance)")
        }
    }
    
    public func bestTourInCurrentPopulation() {
        
        if let fittest = population.getFittest() {
            
            print(fittest.totalDistance)
            for city in fittest.cities { print(city.name) }
        }
    }
    
    public func createGeneration() {
        
    }
    
    private func selection() -> [(tour1: Tour, tour2: Tour)] {
        
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
        

        return newGenerationPairs
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
    
    
    private func crossover(pairs: [(tour1: Tour, tour2: Tour)]) -> [Tour] {
        
        // TODO: Error checking -- All Tours should be same size, include the same locations
        
        var newTours = [Tour]()
        
        for (t1, t2) in pairs {
            
//            print("===\nParent 1:", terminator: " ")
//            for c in t1.cities { print(c.name, terminator: " ") }
//            print("\nParent 2:", terminator: " ")
//            for c in t1.cities { print(c.name, terminator: " ") }
//            print("")
            
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
            
//            print("Child 1:", terminator: " ")
//            for c in c1 { print(c.name, terminator: " ") }
//            print("\nChild 2:", terminator: " ")
//            for c in c2 { print(c.name, terminator: " ") }
//            print("\n====")
            
            // copy the tours from the children back into the parents
            newTours.append(Tour(start: startCity, cities: c1))
            newTours.append(Tour(start: startCity, cities: c2))
        }
        
        return newTours
    }
    
    
    private func mutate(tour: inout Tour) {
        
        // For each City in the Tour, consider randomly repositioning it in the sequence
        for i in 0 ..< tour.cities.count {
            
            // Generate random number [0,100)
            let rate = Double(arc4random_uniform(101)) / 100.0
            
            // With probability = mutationRate, swap the city at index i with a random index j
            if (rate < mutationRate) {
                
                // Get another random position to swap City objects
                let j: Int = Int(arc4random_uniform(UInt32(tourSize)))
                
                // Perform the random mutation by swapping the cities
                let temp = tour.cities[i]
                tour.cities[i] = tour.cities[j]
                tour.cities[j] = temp
            }
        }
    }
}

extension Array {
    func shiftRight(amount: Int) -> [Element] {
        //return Array(self[amount ..< self.count] + self[0 ..< amount])
        return Array(self[(self.count - amount) ..< self.count] + self[0 ..< (self.count - amount)])
    }
    
    mutating func shiftRightInPlace(amount: Int) {
        self = shiftRight(amount: amount)
    }
}
