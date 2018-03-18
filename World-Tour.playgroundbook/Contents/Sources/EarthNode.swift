import SceneKit
import UIKit

public class EarthNode: SCNNode {
    
    public override init() {
        super.init()
        
        setup()
        setupClouds()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        
        let material = SCNMaterial()
        material.ambient.contents = UIColor(white:  0.8, alpha: 1)
        
        // Use the open source images
        material.diffuse.contents = UIImage(named: "diffuse.jpg")!
        material.specular.contents = UIImage(named: "specular.jpg")!
        material.normal.contents = UIImage(named: "normal.jpg")!
        material.emission.contents = UIImage(named: "lights.jpg")!
        
        material.specular.intensity = 1
        material.shininess = 0.04
        material.multiply.contents = UIColor(white:  0.8, alpha: 1)
        
        let sphere = SCNSphere(radius: 5)
        sphere.firstMaterial = material
        self.geometry = sphere
    }
    
    private func setupClouds() {
        
        // Create cloud aura around the Earth (slighly larger than Earth radius)
        let clouds = SCNSphere(radius: 5.075)
        clouds.segmentCount = 120;
        
        // Create cloud material based on clouds image
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        material.transparent.contents = UIImage(named: "clouds.jpg")!
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
        
        // Set material of the sphere node
        clouds.firstMaterial = material
        
        let cloudsNode = SCNNode()
        cloudsNode.geometry = clouds
        cloudsNode.opacity = 0.35
        cloudsNode.rotation = SCNVector4Make(0, 1, 0, 0);
        
        // Add cloudsNode as a child node to this EarthNode
        self.addChildNode(cloudsNode)
    }
}
