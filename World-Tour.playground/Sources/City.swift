import Foundation

public struct City : Equatable, Codable {
    
    let name: String!
    let latitude: Double!
    let longitude: Double!
    
    //let location: (x: Double, y: Double)!
    
    private enum CodingKeys: String, CodingKey {
        case name = "city"
        case latitude = "lat"
        case longitude = "lng"
    }
    
    public init(name: String, lat: Double, lng: Double) {
        
        self.name = name
        self.latitude = lat
        self.longitude = lng
        //self.location = (x, y)
    }
    
    // Custom initializer using Decoder to decode from JSON
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: CodingKeys.name)

        
        let latString = try container.decode(String.self, forKey: CodingKeys.latitude)
        let lngString = try container.decode(String.self, forKey: CodingKeys.longitude)
        
        // Attempt to convert lat/lng String reprsentations to Doubles
        guard let lat = Double(latString), let lng = Double(lngString) else {
            let context = DecodingError.Context(codingPath: container.codingPath +
                [CodingKeys.latitude, CodingKeys.longitude], debugDescription: "Error parsing lat/lng to Double")
            throw DecodingError.dataCorrupted(context)
        }
        
        self.latitude = lat
        self.longitude = lng
    }
    
    public func distanceBetween(city: City) -> Double {
        
        // Distance is defined as the Euclidean distance between two locations
        return sqrt(
            pow((self.latitude - city.latitude), 2) +
            pow((self.longitude - city.longitude), 2)
        )
    }
    
    public static func ==(left: City, right: City) -> Bool {
        return left.name == right.name &&
            left.latitude == right.latitude &&
            left.longitude == right.longitude
    }
}
