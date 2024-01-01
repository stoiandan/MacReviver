//
//  AutoDetector.swift
//  MacReviver
//
//  Created by Dan Stoian on 01.01.2024.
//

import Foundation
import Virtualization



func autoDetect() async -> DetailSoftwareViewModel? {
    guard let restoreImage = try? await VZMacOSRestoreImage.latestSupported else {
        return nil
    }
    
    let softwareVersion = SoftwareVersion(build: restoreImage.buildVersion, firmwareSHA1: nil, firmwareURL: restoreImage.url.absoluteString)
    
    return DetailSoftwareViewModel(softwareVersion)
}
