import UIKit
import CoreLocation
import MapKit



class MainViewController: UIViewController, SendCoordinates  {
   
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet weak var skyCondition: UIImageView!
    @IBOutlet weak var dayTableView: UITableView!
    @IBOutlet weak var hourCollectionView: UICollectionView!
    
    var forecast: ForecastData?
    let hourCellReuseIdentifier = "hourCellReuseIdentifier"
    let dailyCellReuseIdentifier = "dailyCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
        setTableView()
        setCollectionView()
        NetworkRequest.fetchData(lat: 47.8529, lon: 35.1725) { forecastData in
            DispatchQueue.main.async {
                self.forecast = forecastData
                self.dayTableView.reloadData()
                self.getCurrentweather()
                self.hourCollectionView.reloadData()
            }
        }
    }
    @IBAction func searchCityButton(_ sender: Any) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            let mapVC: MapViewController = segue.destination as! MapViewController
            mapVC.delegate = self
        }
    }
    func setTableView(){
        dayTableView.register(UINib(nibName: "DailyTableVCell", bundle: nil), forCellReuseIdentifier: dailyCellReuseIdentifier)
        dayTableView.dataSource = self
        dayTableView.delegate = self
        
    }
    func setCollectionView(){
        hourCollectionView.register(UINib(nibName: "HourCollectionVCell", bundle: nil), forCellWithReuseIdentifier: hourCellReuseIdentifier)
        hourCollectionView.dataSource = self
        hourCollectionView.delegate = self
    }
    func getCurrentweather(){
        let temp = ((forecast?.list[0].main.tempMax ?? 999.0) - 273.5).rounded()
        self.temperature.text = String(temp)
        self.humidity.text = String(forecast?.list[0].main.humidity ?? 50)
        let currentDay = Double(forecast?.list[0].date ?? 1671235200)
        let dateTimeStamp = Date(timeIntervalSince1970: currentDay)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        let strDateSelect = dateFormatter.string(from: dateTimeStamp)
        self.currentDate.text = strDateSelect
        self.currentCity.text = forecast?.city.name
        switch forecast?.list[0].weather[0].skyCondition {
        case "Rain":
            self.skyCondition.image = UIImage(systemName: "cloud.rain.fill")
        case "Snow":
            self.skyCondition.image = UIImage(systemName: "snowflake")
        case "Clear":
            self.skyCondition.image = UIImage(systemName: "sun.min.fill")
        case "Clouds":
            self.skyCondition.image = UIImage(systemName: "cloud.fill")
        default:
            self.skyCondition.image = UIImage(systemName: "cloud.sun")
        }
    }
    
    func currentCoordinates(lat: Double, lon: Double) {
        NetworkRequest.fetchData(lat: lat, lon: lon) { forecastData in
            DispatchQueue.main.async {
                self.forecast = forecastData
                self.dayTableView.reloadData()
                self.getCurrentweather()
                self.hourCollectionView.reloadData()
            }
        }
    }

    func dailyForecast(index: IndexPath){
        if index.row < 5 {
            let temp = ((forecast?.list[index.row * 8].main.tempMax ?? 999.0) - 273.5).rounded()
            self.temperature.text = String(temp)
            self.humidity.text = String(forecast?.list[index.row * 8].main.humidity ?? 50)
            self.wind.text = forecast?.list[index.row * 8].weather[0].skyCondition
            
            let currentDay = Double(forecast?.list[index.row * 8].date ?? 1671235200)
            let dateTimeStamp = Date(timeIntervalSince1970: currentDay)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM"
            let strDateSelect = dateFormatter.string(from: dateTimeStamp)
            self.currentDate.text = strDateSelect
            
            switch forecast?.list[index.row * 8].weather[0].skyCondition {
            case "Rain":
                self.skyCondition.image = UIImage(systemName: "cloud.rain.fill")
            case "Snow":
                self.skyCondition.image = UIImage(systemName: "snowflake")
            case "Clear":
                self.skyCondition.image = UIImage(systemName: "sun.min.fill")
            case "Clouds":
                self.skyCondition.image = UIImage(systemName: "cloud.fill")
            default:
                self.skyCondition.image = UIImage(systemName: "cloud.sun")
            }
        }
        
    }
}

//MARK: CollectionView Configurationn
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hourCellReuseIdentifier, for: indexPath) as! HourCollectionVCell
        cell.configureCell(time: Double(forecast?.list[indexPath.item].date ?? 1671235200),
                           skyConditionHourly: forecast?.list[indexPath.item].weather[0].skyCondition ?? "Clear",
                           temp: forecast?.list[indexPath.item].main.tempMin ?? 277)
        
        return cell
    }
}
//MARK: TableView Configuaration

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dailyCellReuseIdentifier, for: indexPath) as! DailyTableVCell
        
        if indexPath.row < 40 {
            cell.configureCell(dayDaily: Double(forecast?.list[indexPath.row * 8].date ?? 1671235200),
                               minTempDaily: Double(forecast?.list[indexPath.row * 8].main.tempMin ?? 277),
                               maxTempDaily: Double(forecast?.list[indexPath.row * 8].main.tempMax ?? 280),
                               skyConditionDaily: forecast?.list[indexPath.row * 8].weather[0].skyCondition ?? "Clear")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dailyForecast(index: indexPath)
        hourCollectionView.reloadData()
    }
}


