import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
   
    let locationManager = CLLocationManager()
    lazy var searchBar = UISearchBar()
    var dataParsing = NetworkRequest()
    var delegate: SendCoordinates? = nil
    var lat: Double?
    var lon: Double?
    @IBOutlet weak var getCurrentCondition: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        setupSearchBar()
        locationManager.requestLocation()
    }
    private func setupSearchBar (){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search city"
        searchBar.isTranslucent = false
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }

    @IBAction func getCurrentLocation(_ sender: Any) {
        if self.delegate != nil && lat != nil && lon != nil {
            self.delegate?.currentCoordinates(lat: lat ?? 47.8529, lon: lon ?? 35.1725)
            navigationController?.popViewController(animated: true)
        }
    }
}
extension MapViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Location data received.")
            print(location.coordinate.longitude)
            print(location.coordinate.latitude)
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get users location.")
    }
}




protocol SendCoordinates {
    func currentCoordinates(lat: Double, lon: Double)
}

extension MapViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}
