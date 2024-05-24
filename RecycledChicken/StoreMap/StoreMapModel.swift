//
//  StoreMapModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/23.
//

import Foundation

struct MapInfo: Codable {
//    var isVisible:Bool?
//    var storeName:String
//    var storeID:String
//    var cellPath:String
//    var remainingProcessable:RemainingProcessableInfo
//    var status:String
//    var storeAddress:String
//    var coordinate:String
//    var disance:Double = 0
    var name:String?
    var machineRemaining:MachineRemaining?
    var machineStatus:MachineStatus?
    var machineLocation:MachineLocation?
    var address:String?
    var taskDescription:String?
    
    enum CodingKeys:String, CodingKey {
        case name = "name"
        case machineRemaining = "remaining"
        case machineStatus = "status"
        case machineLocation = "location"
        case address = "address"
        case taskDescription = "taskDescription"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        machineRemaining = try? container.decodeIfPresent(MachineRemaining.self, forKey: .machineRemaining)
        machineStatus = try? container.decodeIfPresent(MachineStatus.self, forKey: .machineStatus)
        machineLocation = try? container.decodeIfPresent(MachineLocation.self, forKey: .machineLocation)
        address = try? container.decodeIfPresent(String.self, forKey: .address)
        taskDescription = try? container.decodeIfPresent(String.self, forKey: .taskDescription)
    }
}

enum MachineStatus:String, Codable {
    case full = "滿位"
    case submit = "可投"
    case underMaintenance = "維護"
}

struct MachineRemaining:Codable {
    var bottle:Int?
    var colorBottle:Int?
    var battery:Int?
    var can:Int?
    var cup:Int?
}

struct MachineLocation:Codable {
    var latitude:String?
    var longitude:String?
}

struct RemainingProcessableInfo: Codable {
    var bottle:Int?
    var battery:Int?
}

