import SceneKit

public class WorldViewController: UIViewController {
    
    // Encapsulate a single WorldView inside this controller
    var worldView: WorldView!
    
    
    // Standard initializer
    public init () {
        super.init(nibName: nil, bundle: nil)
        
        // Instantiate the WorldView
        // TODO: Shouldn't be hardcoding dimensions here
        worldView = WorldView(frame: CGRect(x: 0, y: 0, width: 512, height: 384))
        self.view = worldView
    }


    // Required initializer
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Handle arrival of each touch event in the view controller
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            if let hit = worldView.hitTest(touch.location(in: worldView), options: nil).first {
                
                // Obtain the (world space) intersection point of casted ray and (Earth) node
                let intersectionCoord = hit.localCoordinates
                let intersectionNormal = hit.localNormal
                
//                print("World POI:    \(hit.worldCoordinates)")
//                print("World Normal: \(hit.worldNormal)")
//                print("POI node:     \(hit.node)")
                
                
                // Spawn a thumbtack here
                // TODO: Account for thumbtack angle, should be normal to the POI on Earth
                worldView.worldScene.spawnThumbtackAt(position: intersectionCoord,
                                                      rotation: intersectionNormal)
            
            } else { print("Error: hitTest() has no first SCNHitTestResult") }
        } else { print("Error: touchesBegan() has no UITouch objects") }
    }
}
