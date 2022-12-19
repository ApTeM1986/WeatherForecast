import Foundation

struct ForecastData: Codable {
    let list: [ForecastDetails]
    let city: CityName
}
struct CityName: Codable {
    let name: String
}
struct ForecastDetails: Codable { 
    let date: Int
    let main: Tempdetails
    let weather: [SkyCondition]
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main
        case weather
    }
    
}

struct Tempdetails: Codable {
    let tempMin: Double
    let tempMax: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}

struct SkyCondition: Codable {
    let skyCondition: String
    
    enum CodingKeys: String, CodingKey {
        case skyCondition = "main"
    }
}
