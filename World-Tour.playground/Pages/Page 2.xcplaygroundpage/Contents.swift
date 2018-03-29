//
// World Tour
//
// A fully interactive 3D scene, displaying Earth and animating paths and
// an airplane to travel them.
//

import PlaygroundSupport
import UIKit
import SceneKit

public class TempView: SCNView {
    
    let worldScene = TempScene()
    
    public override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        
        // Establish default view properties
        allowsCameraControl = true
        autoenablesDefaultLighting = true
        
        backgroundColor = UIColor.black
        self.scene = worldScene
    }
    
    public required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class TempController: UIViewController {
    
    // Encapsulate a single WorldView inside this controller
    var worldView: TempView!
    
    
    // Standard initializer
    public init () {
        super.init(nibName: nil, bundle: nil)
        
        // Instantiate the WorldView
        // TODO: Shouldn't be hardcoding dimensions here
        worldView = TempView(frame: CGRect(x: 0, y: 0, width: 512, height: 384))
        self.view = worldView
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class TempScene: SCNScene {
    
    public override init() {
        super.init()
        
        // Test space for the genetic algorithm
        var cities = CityFactory.createCitiesFromJSON()
        
        let startCity = cities.first!
        cities = Array(cities[1...])
        
        let algo = GeneticAlgorithm(populationSize: cities.count, mutationRate: 0.3,
                                    startCity: startCity, cities: cities)
        
        algo.simulateNGenerations(n: 10)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


PlaygroundPage.current.liveView = TempController()

