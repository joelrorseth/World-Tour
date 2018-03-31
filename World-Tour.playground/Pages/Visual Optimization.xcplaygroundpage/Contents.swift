/*:
 ### Visual Optimization
 
 Now that you understand the steps behind the Genetic Algorithm, we will apply a
 compiled Swift implementation to a real example. In the *live view* to the right, a map
 of Canada (the author's home country) has been rendered. Click on the live view to
 drop markers around the map, choosing locations that the Canadian Travelling Salesman
 must travel to. As Canada is a very large country, remember to tune your Genetic
 Algorithm parameters very carefully to avoid unneccessary hardship on the Canadian
 Travelling Salesman!
 
 */

import PlaygroundSupport
import UIKit


// Define the number of solutions that will evolve in our population
let populationSize = 50

// Number of generations to evolve the population
let numGenerations = 200

// The probability (in whole number percentage) of a random sequence mutation
let mutationRate = 1.5




// MARK: Setup
let parameters = GeneticParameters(populationSize: populationSize,
    numberOfGenerations: numGenerations, mutationRate: mutationRate)

let screenSize = CGSize(width: 600, height: 600)
let mapVC = MapViewController()
mapVC.preferredContentSize = screenSize

PlaygroundPage.current.liveView = mapVC
let scene = MapScene(size: screenSize)
scene.simulationParameters = parameters
mapVC.presentScene(scene: scene)

