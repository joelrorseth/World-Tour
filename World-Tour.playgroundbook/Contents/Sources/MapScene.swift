import SpriteKit

public class MapScene: SKScene {
    
    var background: SKSpriteNode!
    var cam: SKCameraNode!
    var markerNodes: [SKNode] = []
    
    
    // =====================================
    // =====================================
    override public func didMove(to view: SKView) {
        
        self.isUserInteractionEnabled = true
        
        // Add the map, our background, as a node
        background = SKSpriteNode(imageNamed: "canada.jpg")
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
    
    // Render a path (node) between two points in the scene
    public func drawPath(from pointA: CGPoint, to pointB: CGPoint, width: CGFloat) {
        
        // TODO
        
        let edgePath  = CGMutablePath()
        edgePath.move(to: CGPoint(x: pointA.x, y: pointA.y))
        edgePath.addLine(to: CGPoint(x: pointB.x, y: pointB.y))
        
        // Create a SKShapeNode to represent the edge as a straight line
        let shape = SKShapeNode()
        shape.path = edgePath
        shape.strokeColor = SKColor.black
        shape.lineWidth = width
        shape.zPosition = 4
        
        addChild(shape)
    }
}
