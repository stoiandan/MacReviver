//
//  MainViewModel.swift
//  MacReviver
//
//  Created by Dan Stoian on 09.06.2023.
//

import Foundation
import SwiftData

@Observable
class MainViewModel {
    
    private var detailVieModelMap: [UUID:DetailSoftwareViewModel] = [:]
    
    private(set) var hardwareVersions: [HardwareVersion] = []
    
    var selectedSwVersion: SoftwareVersion? = nil
    
    private(set) var errorMessae = ""
    
    func fetchHardwareVersions() async {
        let plist = try? await PlistFirmwareFetcher.plistFirmware()
        
        guard let plist else {
            errorMessae = "Could not fetch plist"
            return
        }
        
        
        let plistFirmware = try? PlistFirmware(plist: plist)
        
        guard let plistFirmware else {
            errorMessae = "Could not parse plist Firmware"
            return
        }
        
        hardwareVersions = plistFirmware.hardwareVersions
    }
    
    var detailViewModel: DetailSoftwareViewModel {
        if let vm = detailVieModelMap[selectedSwVersion!.id] {
            return vm
        }
        let vm = DetailSoftwareViewModel(selectedSwVersion!)
        detailVieModelMap[selectedSwVersion!.id] = vm
        return vm
    }
}



struct HardwareVersion: Identifiable, Hashable {
    let id = UUID()
    let name: String
    
    let versions: [SoftwareVersion]
}

struct SoftwareVersion: Identifiable, Hashable {
    let id = UUID()
    let build: String
    let firmwareSHA1: String?
    let firmwareURL: String
    
    var name: String {
        URL(string: firmwareURL)!.lastPathComponent
    }
}
