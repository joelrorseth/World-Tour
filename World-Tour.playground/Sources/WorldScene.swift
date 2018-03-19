import SceneKit
import UIKit

public class WorldScene: SCNScene {
    
    // Scene nodes
    let earthNode = EarthNode()
    let cameraNode = SCNNode()
    let sunNode = SCNNode()
    let cloudsNode = SCNNode()
    
    var sunNodeRotation = Float(Double.pi / 2)
    
    
    public override init() {
        super.init()
        
        setupEarth()
        setupCamera()
        setupSun()
        setupStars()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Convenience function to spawn a ThumbtackNode at a position in world space
    public func spawnThumbtackAt(_ position: SCNVector3) {
    
        let tack = ThumbtackNode()
        tack.position = position
        rootNode.addChildNode(tack)
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
}

