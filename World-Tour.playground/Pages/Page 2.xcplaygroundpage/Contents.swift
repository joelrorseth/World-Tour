/*:
 ### Table of Contents
 
 1. [Genetic Algorithms](GA)
 2. [Tuning Parameters](Parameters)
 3. [Bonus](Bonus)
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

let mapVC = MapViewController()
mapVC.preferredContentSize = CGSize(width: 600, height: 600)
PlaygroundPage.current.liveView = mapVC
