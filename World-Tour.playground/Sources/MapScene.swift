import SpriteKit

public class MapScene: SKScene {
    
    var background: SKSpriteNode!
    var cam: SKCameraNode!
    var markerNodes: [SKNode] = []
    var pathNodes: [SKNode] = []
    var distanceTextView: UITextView!
    
    // MARK: View Lifecycle
    override public func didMove(to view: SKView) {
        
        self.isUserInteractionEnabled = true
        
        // Add the map, our background, as a node
        background = SKSpriteNode(imageNamed: "canada.png")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.isUserInteractionEnabled = false
        addChild(background)
        
        // Add our own camera node for better control
        cam = SKCameraNode()
        cam.position = CGPoint(x: frame.midX, y: frame.midY)
        cam.xScale = 3
        cam.yScale = 3

        self.camera = cam
        self.addChild(cam)
        
        // Add gesture recognizer to view for pinch gestures
        let pinchGesture = UIPinchGestureRecognizer(
            target: self, action: #selector(self.handlePinch(_:)))
        self.view?.addGestureRecognizer(pinchGesture)
        
        setupToolbar(view: view)
    }
    
    
    // MARK: Toolbar
    // Estblish a toolbar to control the simulation
    private func setupToolbar(view: SKView) {
        
        // Define UIToolbar at top of screen
        let toolbar = UIToolbar(frame:
            CGRect(x: 0, y: 0, width: frame.size.width, height: 44))
        
        // Add buttons to start / stop the simulation
        let startItem = UIBarButtonItem(title: "Start",
            style: UIBarButtonItemStyle.plain, target: self,
            action: #selector(toolbarButtonClicked))
        
        let stopItem = UIBarButtonItem(title: "Reset",
            style: UIBarButtonItemStyle.plain, target: self,
            action: #selector(toolbarButtonClicked))
        
        // Add text view to show the distance of the current path
        distanceTextView = UITextView(frame:
            CGRect(x: 0, y: 0, width: frame.size.width/2, height: 44))
        
        distanceTextView.backgroundColor = UIColor.clear
        distanceTextView.text = ""
        distanceTextView.contentInset = UIEdgeInsetsMake(4.0, 0, 0, 0)
        distanceTextView.textAlignment = NSTextAlignment.center
        distanceTextView.font = UIFont.boldSystemFont(ofSize: 17)
        distanceTextView.isEditable = false
        
        let distanceItem = UIBarButtonItem(customView: distanceTextView)
        
        // Use flexible space item to center the distance text view
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
            target: nil, action: nil)
        
        toolbar.setItems([startItem, spacer, distanceItem, spacer, stopItem], animated: true)
        view.addSubview(toolbar)
    }
    
    // Handler for bar button item selection within the toolbar
    @objc public func toolbarButtonClicked(sender: UIBarButtonItem) {
        guard let title = sender.title else { return }
        
        switch (title) {
            
        case "Start":
            startGeneticAlgorithm()
            break
            
        case "Reset":
            resetGeneticAlgorithm()
            break
            
        default:
            break
        }
    }
    
    
    // MARK: Simulation Control
    public func startGeneticAlgorithm() {
        
        if markerNodes.count <= 2 { return }
        distanceTextView.text = "Running..."
        
        //var cities = CityFactory.createCitiesFromJSON()
        var cities = CityFactory.createCitiesFromNodes(
            nodes: markerNodes, parent: background)
        
        let startCity = cities.first!
        cities = Array(cities[1...])
        
        // Create genetic algorithm instance with parameters
        let algo = GeneticAlgorithm(populationSize: 100, mutationRate: 1.5,
                                    startCity: startCity, cities: cities)
        algo.simulationDelegate = self
        
        DispatchQueue.global(qos: .background).async {
            print("Scene has called GA on background thread")
            
            // Print results of genetic simulation
            let bestSequence = algo.simulateNGenerations(n: 50)
            
            DispatchQueue.main.async {
                print("Scene main queue is processing the results")
                
                guard let sequence = bestSequence else { return }
                for city in sequence.cities {
                    print(city.name, terminator: "->")
                }
            }
        }
    }
    
    public func resetGeneticAlgorithm() {
        
        background.removeAllChildren()
        markerNodes.removeAll()
        pathNodes.removeAll()
        
        distanceTextView.text = ""
    }
    
    
    // MARK: Touch Events
    // Handler function for touch events occuring in the scene
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
        
            // Obtain CGPoint of touch location in the scene itself
            let touchPosition = touch.location(in: self)
            dropMarker(at: touchPosition)
        }
    }
    
    // Handler function for pinch gestures
    @objc public func handlePinch(_ sender: UIPinchGestureRecognizer) {

        // Scale the background node and all children (markers, paths)
        let pinchScaleTransform = SKAction.scale(by: sender.scale, duration: 0.0)
        background.run(pinchScaleTransform)
        sender.scale = 1.0
    }
    
    
    // MARK: Drawing
    // Add a marker node at the provided scene coordinate
    public func dropMarker(at point: CGPoint) {
        
        // Convert view coordinates to coordinate system of the background node
        let touchPosition = convert(point, to: self.background)
        
        // Add the marker node at this location, but as child of background
        let marker = SKShapeNode(circleOfRadius: 10)
        marker.position = touchPosition
        marker.fillColor = .red
        marker.strokeColor = .black
        marker.glowWidth = 1.0
        marker.zPosition = CGFloat(10)
        
        markerNodes.append(marker)
        self.background.addChild(marker)
    }
    
    // Draw a path between two cities (coordinates relative to parent node)
    public func drawPathBetween(cityA: City, cityB: City, color: UIColor) {
        
        let ptA = CGPoint(x: cityA.latitude, y: cityA.longitude)
        let ptB = CGPoint(x: cityB.latitude, y: cityB.longitude)
        
        // Draw a path between the x,y world / scene position of both cities
//        drawPath(from: convert(ptA, from: background),
//                 to: convert(ptB, from: background), color: color)
        
        drawPath(from: ptA, to: ptB, color: color)
    }
    
    // Render a path (node) between two points in the scene, relative to background node
    public func drawPath(from pointA: CGPoint, to pointB: CGPoint, color: UIColor) {
        
        // TODO
        let edgePath  = CGMutablePath()
        edgePath.move(to: CGPoint(x: pointA.x, y: pointA.y))
        edgePath.addLine(to: CGPoint(x: pointB.x, y: pointB.y))
        
        // Create a SKShapeNode to represent the edge as a straight line
        let shape = SKShapeNode()
        shape.path = edgePath
        shape.strokeColor = .red
        shape.lineWidth = 8.0
        shape.zPosition = 4
        shape.isHidden = true
        
        pathNodes.append(shape)
        background.addChild(shape)
    }
}


extension MapScene: SimulationDelegate {
    
    public func yieldNewGeneration(fittest: Tour) {
        
        pathNodes.removeAll()
        
        
        drawPathBetween(cityA: fittest.startCity,
                        cityB: fittest.cities.first!,
                        color: UIColor(red: 0, green: 0, blue: 0.3, alpha: 1))
        
        let numPaths = fittest.cities.count - 1
        
        // Draw the sequence of cities defined by this Tour
        for i in 0..<numPaths {
            
            let color = UIColor(
                red: CGFloat(Double(i)/Double(numPaths)),
                green: 0,
                blue: 0.3,
                alpha: 1.0)
            
            UIView.animate(withDuration: 5) {
                
                self.drawPathBetween(cityA: fittest.cities[i],
                            cityB: fittest.cities[i+1],
                            color: color)
            }
        }
        
        // Draw path between start city -> first city, last city -> start city
        drawPathBetween(cityA: fittest.cities.last!,
                        cityB: fittest.startCity,
                        color: UIColor(red: 1, green: 0, blue: 0.3, alpha: 1))
        
        distanceTextView.text = "\(Int(fittest.totalDistance)) km"
        animateNodes(pathNodes)
    }
    
    public func animateNodes(_ nodes: [SKNode]) {
        for (index, node) in nodes.enumerated() {
            node.run(.sequence([
                .wait(forDuration: TimeInterval(index) * 0.2),
                .repeat(.sequence([
                    .unhide(),
                    .wait(forDuration: 2)
                    ]), count: 1)
                ]))
        }
    }
}
