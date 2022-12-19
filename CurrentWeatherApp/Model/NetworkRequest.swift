import Foundation

class NetworkRequest {

    static func fetchData(lat: Double, lon: Double, completion: @escaping (ForecastData) -> Void){
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=832ab4e4f31cd95e55250483d0b4de1c")
       
        let request = URLRequest(url: url!)
   
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard let data = data else {return}
                let forecastData = try JSONDecoder().decode(ForecastData.self, from: data)
//                print(forecastData)
                completion(forecastData)


            } catch  let error as NSError {
                print(error.localizedDescription)
            }
        } .resume()

       
    }
    

}
