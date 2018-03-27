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
    public func spawnThumbtackAt(position: SCNVector3, rotation: SCNVector3) {
    
        //let tack = ThumbtackNode()
        //tack.position = position
        
        // Create a red sphere for now
        let material = SCNMaterial()
        material.ambient.contents = UIColor(white:  0.8, alpha: 1)
        
        material.diffuse.contents  = UIColor.red
        material.specular.intensity = 1
        material.shininess = 0.3
        material.multiply.contents = UIColor(white:  0.8, alpha: 1)
        
        let sphere = SCNSphere(radius: 0.1)
        sphere.firstMaterial = material
        let node = SCNNode(geometry: sphere)
        node.position = position
        
        // Add marker as a child of the earth node
        earthNode.addChildNode(node)
    }
    
    
    // TODO: This could potentially work for rotating to orientation
    /*
    func dirToAngle(_ dir: Float) -> Float {
        
        // 0 degrees is 1.0f, 45 degrees is 0.5f, 90 degrees is 0.0f,
        // 135 degrees is -0.5f, and 180 degrees is -1.0f
        
        var current_angle: Float = 0.0
        var current_dir: Float = 1.0
        
        while current_dir >= dir && current_dir >= -1.0 {
            current_angle += 9.0
            current_dir -= 0.1
        }
        
        return current_angle
        
//        if (dir >= 1.0) { return 0.0 }
//        else if (dir >= 0.5) { return 45.0 }
//        else if (dir >= 0.0) { return 90.0 }
//        else if (dir >= -0.5) { return 135.0 }
//        else { return 180.0 }
    }
    */
    
    
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

