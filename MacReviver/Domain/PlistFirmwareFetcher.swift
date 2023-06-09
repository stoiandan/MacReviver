//
//  FirmwarePlistParser.swift
//  MacReviver
//
//  Created by Dan Stoian on 09.06.2023.
//

import Foundation


enum PlistFirmwareFetcher {
    static let firmwarePlistURL = "https://mesu.apple.com/assets/macos/com_apple_macOSIPSW/com_apple_macOSIPSW.xml"
    static private let mimeType = "application/xml"
    
    enum FirmwareDownloadError: Error {
        case CoulNotDownload
        case WrongMimeType
        case InvalidXML
    }
    
    public static func plistFirmware() async throws ->  [String:Any]? {
        let response = try await downloadPlist()
        return try isPlistOk(response.0, response.1)
    }
    
    
    private static func downloadPlist() async throws -> (Data, URLResponse) {
        let response = try? await URLSession.shared.data(from: URL(string: PlistFirmwareFetcher.firmwarePlistURL)!)
        
        guard let response else {
            throw FirmwareDownloadError.CoulNotDownload
        }
        return response
    }
    
    private static func isPlistOk(_ plistBinaryData: Data, _ response: URLResponse ) throws -> [String:Any] {
        
        guard let mimeType = response.mimeType,
              mimeType == PlistFirmwareFetcher.mimeType   else {
            throw FirmwareDownloadError.WrongMimeType
        }
        
        return try! PropertyListSerialization.propertyList(from: plistBinaryData, format: nil) as! [String:Any]
    }
}






