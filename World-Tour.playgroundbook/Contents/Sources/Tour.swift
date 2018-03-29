import Foundation

public struct Tour: Comparable {
    
    var startCity: City!
    var cities = [City]()
    
    
    // The distance travelled by the salesman to visit all cities in this Tour sequence
    var totalDistance: Double {
        
        if cities.isEmpty { return 0.0 }
        
        // Account for distance from start point to first stop, and final return trip
        var distance = startCity.distanceBetween(city: cities[0]) +
            startCity.distanceBetween(city: cities.last!)
        
        // Sum all the intermediate distances between this sequence of cities
        for i in 0 ..< (cities.count - 1) {
            distance += cities[i].distanceBetween(city: cities[i + 1])
        }
        
        return distance
    }
    
    // The fitness of a genetic sequence is determined by some heuristic
    // For our purposes, fitness is more optimal as total distance approaches 0
    var fitness: Double {
        
        // Here the range of fitness is [0,1]
        return totalDistance != 0.0 ?
            (1.0 / totalDistance) : 0.0
    }
    
    
    // Initializer defines the sequence of cities (the tour)
    // The passed City ordering can be preserved, or randomized to generate a permuted Tour
    public init(start: City, cities: [City], random: Bool = false) {
        self.startCity = start
        self.cities = cities
    }
    
    public mutating func append(city: City) {
        cities.append(city)
    }
    
    public mutating func changeStart(city: City) {
        startCity = city
    }
    
    // Define a better tour as one with shorter total Euclidean distance
    public static func <(left: Tour, right: Tour) -> Bool {
        return left.totalDistance < right.totalDistance
    }
    
    public static func ==(left: Tour, right: Tour) -> Bool {
        return left.totalDistance == right.totalDistance
    }
}