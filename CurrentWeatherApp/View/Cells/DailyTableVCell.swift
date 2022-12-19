import UIKit

class DailyTableVCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var skyCondition: UIImageView!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.customStyleForRowSelection()
        
        dayLabel.text = nil
        skyCondition.image = nil
        minTemp.text = nil
        maxTemp.text = nil
        
    }

    private func customStyleForRowSelection(){
        let customSelection = UIView(frame: bounds)
        customSelection.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        customSelection.layer.shadowColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        customSelection.layer.shadowOpacity = 0.5
        customSelection.layer.shadowRadius = 8
        customSelection.layer.shadowOffset = .zero
        customSelection.layer.borderColor = UIColor.red.cgColor
        self.selectedBackgroundView = customSelection
    }
    
    func configureCell(dayDaily: Double, minTempDaily: Double, maxTempDaily: Double, skyConditionDaily: String){
        let min = (minTempDaily - 273.5).rounded()
        let max = (maxTempDaily - 273.5).rounded()
        minTemp.text = String(min)
        maxTemp.text = String(max)
        let dateTimeStamp = Date(timeIntervalSince1970: dayDaily)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let strDateSelect = dateFormatter.string(from: dateTimeStamp)
        dayLabel.text = strDateSelect
        
        switch skyConditionDaily {
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
