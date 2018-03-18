//
// World Tour
//
// A fully interactive 3D scene, displaying Earth and animating paths and
// an airplane to travel them.
//

import Cocoa
import CoreLocation
import GLKit
import PlaygroundSupport
import ModelIO
import SceneKit.ModelIO
import SceneKit



class WorldScene: SCNScene  {
    
    // Scene nodes
    let earthNode = SCNNode()
    let cameraNode = SCNNode()
    let sunNode = SCNNode()
    let cloudsNode = SCNNode()
    
    let sunNodeRotationSpeed: CGFloat  = CGFloat(Double.pi/6)
    let earthNodeRotationSpeed: CGFloat = CGFloat(Double.pi/40)
    var earthNodeRotation: CGFloat = 0
    var sunNodeRotation: CGFloat = CGFloat(Double.pi/2)
    
    
    override init() {
        super.init()
        
        setupEarth()
        setupCamera()
        setupSun()
        setupCloudsAndHalo()
        setupStars()
        
        // Instantiate a thumbtack
        
        let tn = ThumbtackNode()
        tn.setup()
        rootNode.addChildNode(tn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupEarth() {
        
        let material = SCNMaterial()
        material.ambient.contents = NSColor(white:  0.8, alpha: 1)
        
        // Use the open source images
        material.diffuse.contents = NSImage(named: NSImage.Name(rawValue: "diffuse"))
        material.specular.contents = NSImage(named: NSImage.Name(rawValue: "specular"))
        material.normal.contents = NSImage(named: NSImage.Name(rawValue: "normal"))
        material.emission.contents = NSImage(named: NSImage.Name(rawValue: "lights"))

        material.specular.intensity = 1
        material.shininess = 0.04
        material.multiply.contents = NSColor(white:  0.8, alpha: 1)
        
        let sphere = SCNSphere(radius: 5)
        sphere.firstMaterial = material
        earthNode.geometry = sphere
        
        // Add Earth node to scene object graph
        self.rootNode.addChildNode(earthNode)
    }
    
    func setupCamera() {
        
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 12)
        
        let light = SCNLight()
        light.type = SCNLight.LightType.ambient
        light.color = NSColor(white: 0.01, alpha: 1.0)
        cameraNode.light = light
        
        // Add camera node to scene object graph
        rootNode.addChildNode(cameraNode)
        
    }
    
    func setupSun() {
        
        let light = SCNLight()
        light.type = SCNLight.LightType.directional
        sunNode.light = light
        
        // Sun is rotated out of view
        sunNode.rotation = SCNVector4(x: 0.0, y: 1.0, z: 0.0, w: CGFloat(sunNodeRotation))
        rootNode.addChildNode(sunNode)
    }
    
    
    func setupCloudsAndHalo() {
        
        //Set up clouds material radius slightly bigger than earth
        let clouds = SCNSphere(radius: 5.075)
        clouds.segmentCount = 120;
        
        let material = SCNMaterial()
        material.diffuse.contents = NSColor.white
        material.transparent.contents = NSImage(named: NSImage.Name(rawValue: "clouds"))
        material.transparencyMode = SCNTransparencyMode.rgbZero;
        material.locksAmbientWithDiffuse = true
        material.writesToDepthBuffer = false
        
        // Load GLSL code snippet for Halo effects
        do {
            if let path = Bundle.main.path(forResource: "halo", ofType: "glsl") {
                let glsl = try NSString(contentsOf: URL(fileURLWithPath: path),
                                                encoding: String.Encoding.utf8.rawValue)
                material.shaderModifiers = [SCNShaderModifierEntryPoint.fragment : glsl as String]
            }
        } catch { print("Error: Could not encode glsl as NSString") }
        
        clouds.firstMaterial = material
        cloudsNode.geometry = clouds
        cloudsNode.opacity = 0.35
        cloudsNode.rotation = SCNVector4Make(0, 1, 0, 0);
        
        earthNode.addChildNode(cloudsNode)
    }
    
    func setupStars() {
        
        if let starSystem = SCNParticleSystem(named: "StarParticleSystem.scnp", inDirectory: nil) {
            self.rootNode.addParticleSystem(starSystem)
        } else {
            print("Couldn't add star system")
        }
    }
    
    // Leftwards continuous revolving animation
    func revolve(node: SCNNode, value: CGFloat, increase: CGFloat) -> CGFloat {
        var rotation = value
        
        if value < CGFloat(-Double.pi * 2) {
            
            rotation = value + CGFloat(Double.pi*2)
            node.rotation = SCNVector4(x: 0.0, y: 1.0, z: 0.0, w: rotation)
        }
        
        return rotation - increase
    }
}


class WorldView: SCNView {
    
    let worldScene = WorldScene()
    
    override init(frame: NSRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        
        // Establish default view properties
        allowsCameraControl = true
        autoenablesDefaultLighting = true
        
        // TODO: View background should be space or something
        backgroundColor = NSColor.black
        
        self.scene = worldScene
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// Instantiate iPad resolution proportionate view
PlaygroundPage.current.liveView = WorldView(frame:
    NSRect(x: 0, y: 0, width: 512, height: 384))

//PlaygroundPage.current.liveView = WorldView(frame:
//    NSRect(x: 0, y: 0, width: 1024, height: 768))
