import PlaygroundSupport
import UIKit
import SpriteKit

//PlaygroundPage.current.liveView = MapView(frame: CGRect(x: 0,y: 0, width: 600, height: 600))

let mapVC = MapViewController()
mapVC.preferredContentSize = CGSize(width: 800, height: 800)
PlaygroundPage.current.liveView = mapVC
