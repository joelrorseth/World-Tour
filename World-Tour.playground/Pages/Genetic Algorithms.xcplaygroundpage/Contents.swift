/*:
 
 ### Genetic Algorithms
 
 The **Genetic Algorithm** is an adaptive search algorithm, which models its search strategy on
 the concept of genetic evolution and natural selection. Building on the concept of a random
 search, where solutions are randomly generated in an attempt to find an optimal solution,
 genetic algorithms evolve a set of potential solutions based on good solutions already found.
 The algorithm produces new sets of potential solutions, each time doing so, combining the
 best current solutions to form potentially better solutions in the next set.
 
 */

import PlaygroundSupport
import UIKit

/*:
 We will define our Genetic Algorithm (GA) in terms of the Travelling Salesman Problem (TSP). The
 algorithm seeks to find the most *fit genome*. In the TSP, a *genome*, or *individual*, is a
 sequence of cities. In this playground, a genome is a Tour object, which encapsulates an array
 of City objects. A *population* is created, containing and maintaining a fixed number of genomes.
 Thus, we store an array of Tour objects inside a Population object. The algorithm attempts to
 *evolve* the initial population in generations, aiming to refine each generation with genomes that
 are more *fit* than the previous. The evolution process is defined by **selection** (randomly
 determining parent genomes to reproduce), **crossover** (combining parent genomes to produce new
 genes), and **mutation** (randomly changing a genome in certain spots). After evolving a
 solution, the array (ordered sequence) of City objects by the most fit genome is the optimal,
 approximated solution.
 
 */

// Define the number of 🇨🇦 Canadian cities for the Salesman to travel to
let numberOfCities = 20

// Load cities from JSON, feel free to filter different cities by manipulating these arrays
var allCities = CityFactory.createCitiesFromJSON(number: numberOfCities)

/*:
 - note:
 Our genome will be an ordered sequence of 🇨🇦 Canadian cities, loaded from JSON (see *ca.json*).
 Thus, fitness is defined as the total distance to travel to all cities in sequence, determined
 using stored latitude/longitude. A fit Tour will has a short total distance.
 */

// Use the first city as the starting city, the rest are part of the intermediate sequence
let startCity = allCities[0]
let cities = Array(allCities[1...])

/*:
 ## Population

 To start the algorithm, a **Population** of randomly generated potential solutions is generated.
 When running the genetic simulation, this set of solutions will *evolve*, being replaced with
 (mostly) better solutions, which are the product of *crossover* between certain sequences. The
 Population object will be created automatically for you, using the cities and population size.
*/

// Define the number of solutions to evolve
let populationSize = 10

/*:
 ## Selection
 
 The first step in evolving the current population is to define a method of randomly selecting
 an ideal Tour (sequence), which will eventually mate with another Tour. This selection is influenced
 by the *fitness* of a Tour, with more fit Tours being *proportionally more likely* to be selected
 to mate and help create the next generation. There should still be a chance of less fit Tours being
 selected to reproduce; this is the way that human genetics actually work.
 */

// Select one Tour, with likelihood increasing proportional to fitness within population
public func selection(population: Population, populationTotalDistance: Double) -> Tour {
    
    // Use distance over all Tours to determine a given Tour's proportion!
    //let populationTotalDistance = population.totalDistanceOverAllTours()
    
    // Generate random number in [0,1]
    let fitness = Double(arc4random()) / Double(UINT32_MAX)
    
    var currentFitness: Double = 0.0
    var result: Tour!
    
    // Probability of Tour being selected as parent is equal to its fitness,
    // but proportional to others in population!
    population.tours.forEach { (tour) in
        if currentFitness <= fitness {
            
            // Increase probability threshold and set this tour as current selection
            currentFitness += tour.fitness(
                withPopulationDistance: populationTotalDistance)
            
            result = tour
        }
    }
    
    return result
}

/*:
 ## Crossover
 
 In order to produce the next generation (population), we must determine how to reproduce.
 In simple implementations, crossover can be achieved between two sequences by exchanging
 sections of their sequence about a random index. However, a Tour will not be allowed to
 contain a given City twice as this would violate the TSP requirements. Our goal is to
 produce a single child Tour, who forms a City sequence based upon both parents', but
 avoiding placing duplicate cities in its own sequence.
 
 - note:
 Crossover could also yield two (or more) children, which comes in handy for typical
 problems where regular index crossover naturally yields two new sequences. For this
 playground, the function must return one child.
 
 */

// Determine a method of combining the City sequence of two Tours to procreate
public func produceOffspring(firstParent: Tour, secondParent: Tour) -> Tour {
    
    // Randomly select an index, about which we will combine half of each Tour
    let slice: Int = Int(arc4random_uniform(UInt32(firstParent.cities.count)))
    
    // Child will contain all first parent cities to left of slice index
    var cities: [City] = Array(firstParent.cities[0..<slice])
    
    var idx = slice
    while cities.count < secondParent.cities.count {
        let city = secondParent.cities[idx]
        
        // Add cities after index from second parent, avoiding cities already in sequence
        if cities.contains(city) == false {
            cities.append(city)
        }
        idx = (idx + 1) % secondParent.cities.count
    }
    
    return Tour(start: firstParent.startCity, cities: cities)
}

/*:
 ## Mutation
 
 To prevent the population from evolving too strictly, and becoming *stuck* in a
 specific grouping of related genetic seqeunces, each genome has a random chance of
 experiencing mutation. In typical genetic algorithms, mutation *randomly* decides to
 change one or more element in the genome to another element in the domain. In our TSP
 implementation, we instead swap two City objects in the Tour sequence to avoid
 duplicate / missing cities in the Salesman's path.
 
 */

// Mutation in TSP should randomly swap position of two cities in Tour
public func mutate(tour: Tour, mutationRate: Double) -> Tour {
    var tour = tour
    
    // Generate random number [0,100)
    let rate = Double(arc4random_uniform(101)) / 100.0
    let tourSize = tour.cities.count
    
    // With probability = mutationRate, swap the city at index i with a random index j
    if (rate < mutationRate) {
        
        // Get another random position to swap City objects
        let i: Int = Int(arc4random_uniform(UInt32(tourSize)))
        let j: Int = Int(arc4random_uniform(UInt32(tourSize)))
        
        // Perform the random mutation by swapping the cities
        tour.cities.swapAt(i, j)
    }
    
    return tour
}

/*:
 ## Parameters
 
 With our *selection* and *crossover* procedures defined, we are ready to begin the
 genetic algorithm simulation. To avoid enforce the element of randomness, and to avoid
 getting stuck with non-increasing answers, there is a chance that any sequence being added
 may be randomly rearranged in two indices. Provide this probability, along with the desired
 number of generations to simulate. Higher mutation rate means the search will, more often,
 check slightly mutated sequences and perhaps evolve in its favour should it prove more fit.
 
 */

let numGenerations = 20     // 50 generations will be evolved
let mutationRate = 1.5      // eg. 1.5% chance of mutation

/*:
 
 We have now completed the genetic algorithm for the TSP. In the live view to the right, a
 table is ready to run the GA with the functions and parameters you have specified. Upon
 evolution of each generation, an informational entry is inserted to summarize the Population
 at the specified generation. Select any generation to see more detail about its optimal
 Tour.
 
 - note:
 Due to the nature of Swift Playgrounds, only very small simulations will finish quickly.
 The [next](@next) page will present a compiled implementation, which will run faster and
 let you experiment in a fully interactive demonstration.
 
 */
/*:
 ### Press **Run** to begin the evolution.
 
*/




// MARK: Setup
// Here we are packaging our parameters in a struct to pass to simulation
let parameters = PnPGeneticParameters(populationSize: populationSize,
                                      numberOfGenerations: numGenerations,
                                      mutationRate: mutationRate,
                                      selection: selection,
                                      crossover: produceOffspring,
                                      mutation: mutate
)

// Define the (plug and play) genetic algorithm formally
let geneticAlgorithm = PnPGeneticAlgorithm(
    parameters: parameters,
    startCity: startCity,
    cities: cities)


// The GATableViewController will recieve updates in real time after each generation
// We let it control the simulation to provide these real-time updates

let gaViewController = GATableViewController()
gaViewController.algorithm = geneticAlgorithm
geneticAlgorithm.simulationDelegate = gaViewController


let navigationController = UINavigationController(
    rootViewController: gaViewController)
PlaygroundPage.current.liveView = navigationController
