//
//  PlistFirmware.swift
//  MacReviver
//
//  Created by Dan Stoian on 09.06.2023.
//

import Foundation


struct PlistFirmware {
    let hardwareVersions: [HardwareVersion]
    
    
    init(plist: [String:Any]) throws {
        var hardwareVersions: [HardwareVersion] = []
        let mobileDeviceSoftwareVersionsByVersion = plist["MobileDeviceSoftwareVersionsByVersion"] as! [String:Any]
        
        let one = mobileDeviceSoftwareVersionsByVersion["1"] as! [String:Any]
        
        let  mobileDeviceSoftwareVersions = one["MobileDeviceSoftwareVersions"] as! [String:Any]
        
        for (hardwareVersionKey, hwDict) in mobileDeviceSoftwareVersions {
            var swVersions: [SoftwareVersion] = []
            for(_, restoreDict) in hwDict as! [String:[String:Any]] {
                let key = restoreDict.keys.first!
                if key == "Universal" {
                    continue
                }
                let swDict = restoreDict[key] as! [String:String]
                
                let build = swDict["BuildVersion"]!
                let firmwareSHA1 = swDict["FirmwareSHA1"]
                let firmwareURL = swDict["FirmwareURL"]!
                
                swVersions.append(SoftwareVersion(build: build, firmwareSHA1: firmwareSHA1, firmwareURL: firmwareURL))
            }
            hardwareVersions.append(HardwareVersion(name: hardwareVersionKey, versions: swVersions))
        }
        self.hardwareVersions = hardwareVersions
    }
    
 
    
    
}
