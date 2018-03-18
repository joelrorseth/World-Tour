import SceneKit
import UIKit

public class WorldScene: SCNScene {
    
    // Scene nodes
    let earthNode = EarthNode()
    let cameraNode = SCNNode()
    let sunNode = SCNNode()
    let cloudsNode = SCNNode()
    
    let sunNodeRotationSpeed: CGFloat  = CGFloat(Double.pi/6)
    let earthNodeRotationSpeed: CGFloat = CGFloat(Double.pi/40)
    var earthNodeRotation: CGFloat = 0
    var sunNodeRotation = Float(Double.pi/2)
    
    
    public override init() {
        super.init()
        
        setupEarth()
        setupCamera()
        setupSun()
        
        setupStars()
        
        // Instantiate a thumbtack
        
        let tn = ThumbtackNode()
        //tn.setup()
        rootNode.addChildNode(tn)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupEarth() {
        
        self.rootNode.addChildNode(self.earthNode)
    }
    
    func setupCamera() {
        
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 12)
        
        let light = SCNLight()
        light.type = SCNLight.LightType.ambient
        light.color = UIColor(white: 0.4, alpha: 1.0)
        cameraNode.light = light
        
        // Add camera node to scene object graph
        rootNode.addChildNode(cameraNode)
        
    }
    
    func setupSun() {
        
        let light = SCNLight()
        light.type = SCNLight.LightType.directional
        sunNode.light = light
        
        // Sun is rotated out of view
        //sunNode.rotation = SCNVector4(x: 0.0, y: 1.0, z: 0.0, w: CGFloat(sunNodeRotation))
        
        sunNode.rotation = SCNVector4Make(0.0, 1.0, 0.0, sunNodeRotation)
        rootNode.addChildNode(sunNode)
    }
    
    
    
    
    func setupStars() {
        
        if let starSystem = SCNParticleSystem(named: "StarParticleSystem.scnp", inDirectory: nil) {
            self.rootNode.addParticleSystem(starSystem)
        } else {
            print("Couldn't add star system")
        }
    }
    
    // Leftwards continuous revolving animation
    //    func revolve(node: SCNNode, value: CGFloat, increase: CGFloat) -> CGFloat {
    //        var rotation = value
    //
    //        if value < CGFloat(-Double.pi * 2) {
    //
    //            rotation = value + CGFloat(Double.pi*2)
    //            node.rotation = SCNVector4(x: 0.0, y: 1.0, z: 0.0, w: rotation)
    //        }
    //
    //        return rotation - increase
    //    }
}

