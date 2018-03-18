import SceneKit

public class WorldViewController: UIViewController {
    
    //var gameView: SKView!
    var worldView: WorldView!
    
    public init () {
        super.init(nibName: nil, bundle: nil)
        worldView = WorldView(frame: CGRect(x: 0, y: 0, width: 512, height: 384))
        self.view = worldView
    }


    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    // =====================================
//    // =====================================
//    public override func viewDidLoad() {
//
//        // Underlay will take up entire Playground liveView
//        let backgroundView = UIImageView(image: UIImage(named: "underlay.jpg"))
//        backgroundView.isUserInteractionEnabled = true
//
//        self.view = backgroundView
//
//        // Setup content view, disable automatic constraints
//        gameView = SKView()
//        gameView.translatesAutoresizingMaskIntoConstraints = false
//        gameView.backgroundColor = UIColor.clear
//        self.view.addSubview(gameView)
//
//        // These constraints have lower priority, kick in if it can satisfy others
//        let leading = NSLayoutConstraint(item: gameView,
//                                         attribute: .leading,
//                                         relatedBy: .equal,
//                                         toItem: self.view,
//                                         attribute: .leading,
//                                         multiplier: 1.0,
//                                         constant: 0)
//        leading.priority = UILayoutPriority(750.0)
//
//        let trailing = NSLayoutConstraint(item: gameView,
//                                          attribute: .trailing,
//                                          relatedBy: .equal,
//                                          toItem: self.view,
//                                          attribute: .trailing,
//                                          multiplier: 1.0,
//                                          constant: 0)
//        trailing.priority = UILayoutPriority(750.0)
//
//        // These constraints have highest priority
//        let centerHorizontally = NSLayoutConstraint(item: gameView,
//                                                    attribute: .centerX,
//                                                    relatedBy: .equal,
//                                                    toItem: self.view,
//                                                    attribute: .centerX,
//                                                    multiplier: 1.0,
//                                                    constant: 0.0)
//        centerHorizontally.priority = UILayoutPriority(1000.0)
//
//        let centerVertically = NSLayoutConstraint(item: gameView,
//                                                  attribute: .centerY,
//                                                  relatedBy: .equal,
//                                                  toItem: self.view,
//                                                  attribute: .centerY,
//                                                  multiplier: 1.0,
//                                                  constant: 0.0)
//        centerVertically.priority = UILayoutPriority(1000.0)
//
//        let aspectRatio = NSLayoutConstraint(item: gameView,
//                                             attribute: .height,
//                                             relatedBy: .equal,
//                                             toItem: gameView,
//                                             attribute: .width,
//                                             multiplier: 1.0,
//                                             constant: 0.0)
//        aspectRatio.priority = UILayoutPriority(1000.0)
//
//        let width = NSLayoutConstraint(item: gameView,
//                                       attribute: .width,
//                                       relatedBy: .lessThanOrEqual,
//                                       toItem: self.view,
//                                       attribute: .width,
//                                       multiplier: 1.0,
//                                       constant: 0)
//        width.priority = UILayoutPriority(1000.0)
//
//        let height = NSLayoutConstraint(item: gameView,
//                                        attribute: .height,
//                                        relatedBy: .lessThanOrEqual,
//                                        toItem: self.view,
//                                        attribute: .height,
//                                        multiplier: 1.0,
//                                        constant: 0)
//        height.priority = UILayoutPriority(1000.0)
//
//
//        // Add constraints to the view to resize gameView dynamically
//        // These constraints are especially important on the iPad
//        NSLayoutConstraint.activate([leading, trailing, centerVertically, centerHorizontally, aspectRatio, width, height])
//    }
//
//    // =====================================
//    // =====================================
//    public override func viewDidAppear(_ animated: Bool) {
//
//        // Scene must be setup after gameView size has been determined
//        let scene = BSTScene(size: CGSize(
//            width: gameView.frame.size.width,
//            height: gameView.frame.size.height
//        ))
//
//        // Scene will be identical in size to gameView
//        scene.scaleMode = .aspectFit
//
//        // Create the Binary Search Tree that this scene will be displaying
//        scene.createTree(tree: self.binarySearchTree!)
//        self.gameView.presentScene(scene)
//    }
}
