import SceneKit
import UIKit

public class WorldView: SCNView {
    
    let worldScene = WorldScene()
    
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
