/*:
 ### Table of Contents
 
 1. [Genetic Algorithms](GA)
 2. [Selection](Selection)
 3. [Crossover](Crossover)
 . [Tuning Parameters](Parameters)
 */

/*:
 ## Genetic Algorithm
 
 The **Genetic Algorithm** is an adaptive search algorithm, which models its search strategy on
 the concept of genetic evolution and natural selection. Building on the concept of a random
 search, where solutions are randomly generated in an attempt to find an optimal solution,
 genetic algorithms evolve a set of potential solutions based on good solutions already found.
 The algorithm produces new sets of potential solutions, each time doing so, combining the
 best current solutions to form potentially better solutions in the next set.
 
 */

import PlaygroundSupport
import UIKit
import QuartzCore
/*:
 ## Population

 To start the algorithm, a **Population** of randomly generated potential solutions is generated.
 When running the genetic simulation, this set of solutions will *evolve*, being replaced with
 (mostly) better solutions, which are the product of *crossover* between certain sequences.

 - note:
 A Population object will be created automatically for you later, once you have provided the cities
 to be travelled to. Instead, try tweaking the population size.
*/

// Define the number of solutions that will evolve in our population
let populationSize = 10

// Define the number of 🇨🇦 cities for the Salesman to travel to
let numberOfCities = 20

/*:
 ## Selection
 
 The first step in evolving the current population is to define a method of randomly selecting
 an ideal Tour sequence, which will eventually mate with anothr Tour. This selection is influenced
 by the *fitness* of a Tour, with more fit Tours being *proportionally more likely* to be selected
 to mate and help create the next generation.
 */

// Select a single Tour, with likelihood increasing proportional to fitness within population
public func selection(population: Population,
                       populationTotalDistance: Double) -> Tour {
    
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
            currentFitness += tour.fitness(withPopulationDistance: populationTotalDistance)
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
 avoiding duplicate cities.
 
 - note:
 Crossover could also yield two (or more) children, which comes in handy for typical
 problems where regular index crossover naturally yields two new sequences. For this
 playground, the function must return one child.
 
 */

public func produceOffspring(firstParent: Tour, secondParent: Tour) -> Tour {
    
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
    
    return Tour(start: firstParent.startCity, cities: cities)
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

let numGenerations = 50    // 300 generations evolved
let mutationRate = 1.5      // eg. 1.5% chance of mutation


// Here we are packaging our parameters in a struct to pass to simulation
let parameters = PnPGeneticParameters(populationSize: populationSize,
                                   numberOfGenerations: numGenerations,
                                   mutationRate: mutationRate,
                                   selection: selection,
                                   crossover: produceOffspring
)


/*:
 
 To visualize your custom Genetic Algorithm, a colourful map of the author's home country
 of Canada has been embedded. Click on the map to drop *markers*. Experiment with the
 parameters and watch how the population evolve.
 
 - note:
 Due to the nature of Swift Playgrounds, only very small simulations will finish and show the
 paths in the live view. Instead, look at how the algorithm is working, and how the variables
 in the functions you defined are changing. The [next](@next) page will present a compiled
 implementation, which will run at normal speed.
 
 */



// Our genome will be a sequence of 🇨🇦 cities
// Thus, fitness is based on latitude/longitude and distance from other cities

var allCities = CityFactory.createCitiesFromJSON(number: numberOfCities)

// Use the first city as the starting city

let startCity = allCities[0]
let cities = Array(allCities[1...])


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
