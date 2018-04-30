# World Tour

>An interactive Swift Playground about Genetic Algorithms, designed for Xcode 9.3 as an 
iOS / UIKit playground. This is my winning entry for the WWDC 2018 scholarship 
application. The playground is a practical and highly customizable learning experience,
where you may discover how a well suited Genetic Algorithm can be used to solve
the famous Travelling Salesman Problem (TSP), among other important uses.

</br>
<img src="https://github.com/joelrorseth/World-Tour/blob/master/Screenshots/PlaygroundAlgorithm.png" height="570" width="600">
</br>

# Install Instructions

To run the playground, you will need a compter running macOS and a recent version
of Xcode.

1. In a command line, type `git clone https://github.com/joelrorseth/World-Tour/`
2. Double click / open `World-Tour.playground`.

</br>

# The Genetic Algorithm

The playground consists of three pages, an introduction, the implementation page, then
finally the visualization and tweaking page. The playground guides you to a working
implementation of a genetic algorithm that successfully optimizes a solution for the
famous Travelling Salesman Problem.

## Implementation Page (Genetic Simulation)

The second page embeds all of the major components of the working genetic algorithm 
into the playground, provided alongside explanations and implementation details. The
code provided *works as is*, but the point is to provide a modularized sandbox to
test out your own implementations, tricks, or efficient improvements (maybe try an Elitist 
selection strategy?). For example, there are many different ways to implement the 
**Crossover** process. More importantly, the performance of the algorithm will depend 
on these functions, in combination with defining parameters such as the 
**population size** or **mutation probability**.

</br>
<img src="https://github.com/joelrorseth/World-Tour/blob/master/Screenshots/GeneticSimulation.gif" height="600" width="340">
</br>

The view controller in the live view is a visualization of an instance of your genetic
algorithm implementation. Depending on the parameters and instructions you
programmed in the page (or didn't), you should be able to click **Run** and see a
discernible improvement in successive generations. The algorithm is tasked with
finding the Salesman's shortest path across a number of Canadian cities, so your algorithm
is seeking smaller and smaller total Tour (sequence of cities) distances with each 
generation. Click any generation in the table view to expand the sequence for the optimal 
Tour.

## Visualization Page (Map Visual Simulation)

The third page presents a simplified, interactive representation of the Tour total distance
problem that the previous page proposed. In the playground page, you can try out 
different parameters for the algorithm to be used in this visualization. When you run the
page, a map of Canada will be presented in the live view. Click around on the map to
drop pins, which are locations the Travelling Salesman will travel to. When you have
finalized his tour, click **Start** to start the genetic algorithm. The final, optimal path will
be animated onto the map when the computation has terminated.


</br>
<img src="https://github.com/joelrorseth/World-Tour/blob/master/Screenshots/GeneticMap.gif" height="600" width="598">
</br>

# License
MIT License

Copyright (c) [2018] [Joel Rorseth]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
