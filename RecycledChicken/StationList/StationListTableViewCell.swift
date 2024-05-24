//
//  StationListTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/3/3.
//

import UIKit
import CoreLocation

class StationListTableViewCell: UITableViewCell {
    
    static let identifier = "StationListTableViewCell"
    
    @IBOutlet weak var nameLabel:CustomLabel!
    
    @IBOutlet weak var statusLabel:CustomLabel!
    
    @IBOutlet weak var addressLabel:CustomLabel!
    
    @IBOutlet weak var distanceLabel:UILabel!
    
    private var info:MapInfo?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ info:MapInfo, _ currentLocation:CLLocation?) {
        self.info = info
        nameLabel.text = info.name
        statusLabel.text = info.machineStatus?.rawValue
        addressLabel.text = info.address
        getDisance(currentLocation)
    }
    
    private func getDisance( _ currentLocation:CLLocation?) {
        guard let info = info, let machineLocation = info.machineLocation , let latitudeStr = machineLocation.latitude, let longitudeStr = machineLocation.longitude, let latitude = Double(latitudeStr), let longitude = Double(longitudeStr), let currentLocation = currentLocation else { return }
        let distance = CLLocation(latitude: latitude, longitude: longitude).distance(from: currentLocation) / 1000
        distanceLabel.text = "\(String(format: "%.2f", distance))km"
    }
    
    @IBAction func navigationAction(_ sender:UIButton) {
        guard let info = info, let machineLocation = info.machineLocation , let latitudeStr = machineLocation.latitude, let longitudeStr = machineLocation.longitude else { return }
        
        if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(latitudeStr),\(longitudeStr)&directionsmode=driving") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                if let googleMapURL = URL(string: "itms-apps://itunes.apple.com/app/id585027354"), UIApplication.shared.canOpenURL(googleMapURL) {
                    UIApplication.shared.open(googleMapURL)
                }
            }
        }
    }
    
}
