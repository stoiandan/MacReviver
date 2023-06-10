//
//  DetainSoftwareViewModel.swift
//  MacReviver
//
//  Created by Dan Stoian on 10.06.2023.
//

import Foundation
import SwiftData



@Observable
class DetailSoftwareViewModel {
    private var downloadObserver: NSKeyValueObservation? = nil
    
    
    var isDownloading = false
    
    var errorMessage = ""
        
    private(set) var progress = 0.0
    
    let softwareVersion: SoftwareVersion

    
    init(_ softwareVersion: SoftwareVersion) {
        self.softwareVersion = softwareVersion
    }
    
    func download()  {
        let task = URLSession.shared.downloadTask(with: URL(string: softwareVersion.firmwareURL)!) { localURL, response, error in
            guard error != nil else {
                self.errorMessage = "Could not download firwamre"
                return
            }
            guard (try? FileManager.default.moveItem(at: localURL!, to: URL(string: "~/Downloads")!)) != nil else {
                self.errorMessage = "Failed to move downloaded restore image to Downloads folder"
                return
            }
        }
        
         downloadObserver = task.progress.observe(\.fractionCompleted, options: [.initial, .new]) { (progress, change) in
             self.progress = progress.fractionCompleted
        }
        
        task.resume()
 
    }
    
    
}
