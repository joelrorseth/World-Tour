//
// World Tour
//
// A fully interactive 3D scene, displaying Earth and animating paths and
// an airplane to travel them.
//

import GLKit
import PlaygroundSupport
import ModelIO
import SceneKit.ModelIO
import SceneKit


class WorldView: SCNView {
    
    let worldScene = WorldScene()
    
    override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        
        // Establish default view properties
        allowsCameraControl = true
        autoenablesDefaultLighting = true
        
        backgroundColor = UIColor.black
        self.scene = worldScene
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// Instantiate iPad resolution proportionate view
PlaygroundPage.current.liveView = WorldView(frame:
     CGRect(x: 0, y: 0, width: 512, height: 384))

//PlaygroundPage.current.liveView = WorldView(frame:
//    CGRect(x: 0, y: 0, width: 1024, height: 768))
