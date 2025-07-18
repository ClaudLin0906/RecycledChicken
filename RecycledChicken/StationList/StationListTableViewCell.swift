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
    
    @IBOutlet weak var stationStatusStackView:UIStackView!
    
    private var name:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    nameLabel.text = newValue
                }
            }
        }
    }
    
    private var address:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    addressLabel.text = newValue
                }
            }
        }
    }
    
    private var info:MapInfo?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let name = name, name.contains("中興里") {
            setMachineStatus()
        }
    }
    
    private func setMachineStatus() {
        guard let info = self.info, let machineStatus = info.machineStatus else { 
            stationStatusStackView.isHidden = true
            return
        }
        switch machineStatus {
        case .full:
            stationStatusStackView.isHidden = false
            statusLabel.text = info.machineStatus?.rawValue
        case .submit:
            stationStatusStackView.isHidden = true
        case .underMaintenance:
            stationStatusStackView.isHidden = false
            statusLabel.text = info.machineStatus?.rawValue
        }
    }
    
    func setCell(_ info:MapInfo, _ currentLocation:CLLocation?) {
        self.info = info
        self.setMachineStatus()
        self.name = info.name
        self.address = info.address
        self.getDisance(currentLocation)
    }
    
    private func getDisance(_ currentLocation: CLLocation?) {
        guard let info = info, let machineLocation = info.machineLocation, let latitudeStr = machineLocation.latitude, let longitudeStr = machineLocation.longitude, let latitude = Double(latitudeStr), let longitude = Double(longitudeStr), let currentLocation = currentLocation else { return }
        let distance = CLLocation(latitude: latitude, longitude: longitude).distance(from: currentLocation) / 1000
        let roundedDistance = round(distance * 10) / 10
        let distanceString = String(format: "%.1f", roundedDistance)
        let finalString = distanceString.hasSuffix(".0") ? String(distanceString.dropLast(2)) : distanceString
        distanceLabel.text = "\(finalString)km"
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
