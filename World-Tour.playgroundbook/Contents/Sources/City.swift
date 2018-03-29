import Foundation

public struct City {
    
    let name: String!
    let location: (x: Double, y: Double)!
    
    public init(name: String, x: Double, y: Double) {
        
        self.name = name
        self.location = (x, y)
    }
    
    public func distanceBetween(city: City) -> Double {
        
        // Distance is defined as the Euclidean distance between two locations
        return sqrt(
            pow((self.location.x - city.location.x), 2) +
            pow((self.location.y - city.location.y), 2)
        )
    }
}
