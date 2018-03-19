import SceneKit

public class ThumbtackNode: SCNNode {
    
    public override init() {
        super.init()
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup() {
        
        // Load object from SCN file
        if let assetScene = SCNScene(named: "Thumbtack.scn") {
            
            // Add each component (as a node) of the scene containing the object
            for node in assetScene.rootNode.childNodes {
                
                self.addChildNode(node)
            }
        } else { print("Error: Could not open Thumbtack.scn") }
    }
}
