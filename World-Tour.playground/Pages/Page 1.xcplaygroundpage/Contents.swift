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


PlaygroundPage.current.liveView = WorldViewController()

// Instantiate iPad resolution proportionate view
//PlaygroundPage.current.liveView = WorldView(frame:
//     CGRect(x: 0, y: 0, width: 512, height: 384))

//PlaygroundPage.current.liveView = WorldView(frame:
//    CGRect(x: 0, y: 0, width: 1024, height: 768))
