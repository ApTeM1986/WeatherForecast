import UIKit

class HourCollectionVCell: UICollectionViewCell {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var skyCondition: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(time: Double, skyConditionHourly: String, temp: Double){
       
        let temp = (temp - 273.5).rounded()
        let dateTimeStamp = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strDateSelect = dateFormatter.string(from: dateTimeStamp)
        
        tempLabel.text = String(temp)
        timeLabel.text = strDateSelect
        
        
        switch skyConditionHourly {
        case "Rain":
            skyCondition.image = UIImage(systemName: "cloud.rain.fill")
        case "Snow":
            skyCondition.image = UIImage(systemName: "snowflake")
        case "Clear":
            skyCondition.image = UIImage(systemName: "sun.min.fill")
        case "Clouds":
            skyCondition.image = UIImage(systemName: "cloud.fill")
        default:
            skyCondition.image = UIImage(systemName: "cloud.sun")
        }
        
    }
}
