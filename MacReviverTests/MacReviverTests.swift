//
//  MacReviverTests.swift
//  MacReviverTests
//
//  Created by Dan Stoian on 06.06.2023.
//

import XCTest
@testable import MacReviver

final class MacReviverTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFirmwareURLWorks() {
        let firmwareURL = URL(string: PlistFirmwareFetcher.firmwarePlistURL)
        
        XCTAssertNotNil(firmwareURL)
        
    }

    func testDownloadPlistFirmware() async throws {
        let firmware = try? await PlistFirmwareFetcher.plistFirmware()
        
        XCTAssertNotNil(firmware)
    }

    
    func testPlistFirmware() async throws {
        let firmware = try? await PlistFirmwareFetcher.plistFirmware()
        
        let plistFrimware = try? PlistFirmware(plist: firmware!)
        
        XCTAssertTrue(plistFrimware?.hardwareVersions.count != 0)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
