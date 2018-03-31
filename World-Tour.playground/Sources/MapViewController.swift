import SpriteKit

public class MapViewController: UIViewController {
    
    public var gameView: SKView!
    public var scene: MapScene!
    

    public override func viewDidLoad() {
        
        view.isUserInteractionEnabled = true
        
        // Setup content view, disable automatic constraints
        gameView = SKView()
        gameView.isUserInteractionEnabled = true
        gameView.translatesAutoresizingMaskIntoConstraints = false
        gameView.backgroundColor =
            UIColor(red: 203/255, green: 209/255,blue: 208/255, alpha: 1.0)
        
        view.backgroundColor = UIColor(red: 203/255, green: 209/255,
                                       blue: 208/255, alpha: 1.0)
        self.view.addSubview(gameView)
        
        // These constraints have lower priority, kick in if it can satisfy others
        let leading = NSLayoutConstraint(item: gameView,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .leading,
                                         multiplier: 1.0,
                                         constant: 0)
        leading.priority = UILayoutPriority(750.0)
        
        let trailing = NSLayoutConstraint(item: gameView,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: self.view,
                                          attribute: .trailing,
                                          multiplier: 1.0,
                                          constant: 0)
        trailing.priority = UILayoutPriority(750.0)
        
        let top = NSLayoutConstraint(item: gameView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .top,
                                         multiplier: 1.0,
                                         constant: 0)
        leading.priority = UILayoutPriority(750.0)
        
        let bottom = NSLayoutConstraint(item: gameView,
                                          attribute: .bottom,
                                          relatedBy: .equal,
                                          toItem: self.view,
                                          attribute: .bottom,
                                          multiplier: 1.0,
                                          constant: 0)
        trailing.priority = UILayoutPriority(750.0)
        
        let aspectRatio = NSLayoutConstraint(item: gameView,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: gameView,
                                             attribute: .width,
                                             multiplier: 1.0,
                                             constant: 0.0)
        aspectRatio.priority = UILayoutPriority(1000.0)
        
        let width = NSLayoutConstraint(item: gameView,
                                       attribute: .width,
                                       relatedBy: .lessThanOrEqual,
                                       toItem: self.view,
                                       attribute: .width,
                                       multiplier: 1.0,
                                       constant: 0)
        width.priority = UILayoutPriority(1000.0)
        
        let height = NSLayoutConstraint(item: gameView,
                                        attribute: .height,
                                        relatedBy: .lessThanOrEqual,
                                        toItem: self.view,
                                        attribute: .height,
                                        multiplier: 1.0,
                                        constant: 0)
        height.priority = UILayoutPriority(1000.0)
        
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    

    // Manually present the MapScene
    public func presentScene(scene: MapScene) {
        
        // Match map image background color
        scene.backgroundColor = UIColor(red: 203/255, green: 209/255,
                                        blue: 208/255, alpha: 1.0)
        
        // Scene will be identical in size to gameView
        scene.scaleMode = .aspectFit
        
        // Create the Binary Search Tree that this scene will be displaying
        self.gameView.presentScene(scene)
    }
}
