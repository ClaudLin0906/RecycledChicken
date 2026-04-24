//
//  StoreMapModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/23.
//

import Foundation

struct MapInfo: Codable {
    var name:String?
    var machineRemaining:MachineRemaining?
    var machineStatus:MachineStatus?
    var machineLocation:MachineLocation?
    var address:String?
    var description:String?
    
    enum CodingKeys:String, CodingKey {
        case name = "name"
        case machineRemaining = "remaining"
        case machineStatus = "status"
        case machineLocation = "location"
        case address = "address"
        case description = "description"
    }
    
    init(name: String?, machineRemaining: MachineRemaining? = nil, machineStatus: MachineStatus? = nil, machineLocation: MachineLocation? = nil, address: String? = nil, description: String? = nil) {
        self.name = name
        self.machineRemaining = machineRemaining
        self.machineStatus = machineStatus
        self.machineLocation = machineLocation
        self.address = address
        self.description = description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        machineRemaining = try? container.decodeIfPresent(MachineRemaining.self, forKey: .machineRemaining)
        machineStatus = try? container.decodeIfPresent(MachineStatus.self, forKey: .machineStatus)
        machineLocation = try? container.decodeIfPresent(MachineLocation.self, forKey: .machineLocation)
        address = try? container.decodeIfPresent(String.self, forKey: .address)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
    }
}

enum MachineStatus:String, Codable {
    case full = "滿位"
    case submit = "可投"
    case underMaintenance = "維護"
}

struct MachineRemaining:Codable {
    var battery:Int?
    var bottle:Int?
    var coloredBottle:Int?
    var colorlessBottle:Int?
    var can:Int?
    var cup:Int?
    var hdpeBottle:Int?
    var foilPack:Int?
    var cartonBox:Int?
    
    enum CodingKeys:String, CodingKey {
        case battery = "battery"
        case bottle = "bottle"
        case coloredBottle = "coloredBottle"
        case colorlessBottle = "colorlessBottle"
        case can = "can"
        case cup = "cup"
        case hdpeBottle = "hdpeBottle"
        case foilPack = "foilPack"
        case cartonBox = "cartonBox"
    }
    
    init(battery: Int? = nil, bottle: Int? = nil, coloredBottle: Int? = nil, colorlessBottle: Int? = nil, can: Int? = nil, cup: Int? = nil, hdpeBottle: Int? = nil, foilPack: Int? = nil, cartonBox: Int? = nil) {
        self.battery = battery
        self.bottle = bottle
        self.coloredBottle = coloredBottle
        self.colorlessBottle = colorlessBottle
        self.can = can
        self.cup = cup
        self.hdpeBottle = hdpeBottle
        self.foilPack = foilPack
        self.cartonBox = cartonBox
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        battery = try? container.decodeIfPresent(Int.self, forKey: .battery)
        bottle = try? container.decodeIfPresent(Int.self, forKey: .bottle)
        coloredBottle = try? container.decodeIfPresent(Int.self, forKey: .coloredBottle)
        colorlessBottle = try? container.decodeIfPresent(Int.self, forKey: .colorlessBottle)
        can = try? container.decodeIfPresent(Int.self, forKey: .can)
        cup = try? container.decodeIfPresent(Int.self, forKey: .cup)
        hdpeBottle = try? container.decodeIfPresent(Int.self, forKey: .hdpeBottle)
        foilPack = try? container.decodeIfPresent(Int.self, forKey: .foilPack)
        cartonBox = try? container.decodeIfPresent(Int.self, forKey: .cartonBox)
    }
}
struct MachineLocation: Codable {
    var latitude: String?
    var longitude: String?

    init(latitude: String?, longitude: String?) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct RemainingProcessableInfo: Codable {
    var bottle:Int?
    var battery:Int?
}

