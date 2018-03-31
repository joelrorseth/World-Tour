/*:
 ## Visualization
 
 Now that you understand the steps behind the Genetic Algorithm, we will apply a
 compiled implementation to a real example. In the *live view* to the right, a map
 of Canada (the author's home country) has been rendered. Click on the live view to
 drop markers around the map, choosing locations that the Canadian Travelling Salesman
 must travel to. As Canada is a very large country, remember to tune your Genetic
 Algorithm parameters very carefully to avoid unneccessary hardship on the Canadian
 Travelling Salesman!
 
 
 */

import PlaygroundSupport
import UIKit


//let mapVC = MapViewController()
//mapVC.preferredContentSize = CGSize(width: 600, height: 600)
//
//PlaygroundPage.current.liveView = mapVC
//let scene = MapScene(size: CGSize(
//    width: 600,
//    height: 600
//))
////scene.simulationParameters = parameters
//mapVC.presentScene(scene: scene)

public class VC : UITableViewController {}

let vc = VC()
let m = UINavigationController(rootViewController: vc)
PlaygroundPage.current.liveView = m
