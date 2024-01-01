//
//  DetainSoftwareViewModel.swift
//  MacReviver
//
//  Created by Dan Stoian on 10.06.2023.
//

import Foundation
import SwiftData
import CryptoKit
import SwiftUI

@Observable
class DetailSoftwareViewModel {
    
    var copiedState: CopiedState = .none
    
    
    private var downloadObserver: NSKeyValueObservation? = nil
    
    
    private(set) var donwloadState: DownloadState = .notStarted
    
    let softwareVersion: SoftwareVersion
    
    
    init(_ softwareVersion: SoftwareVersion) {
        self.softwareVersion = softwareVersion
    }
    
    func download()  {
        if case .inProgress = donwloadState {
            return
        }
        
        let task = URLSession.shared.downloadTask(with: URL(string: softwareVersion.firmwareURL)!) { localURL, response, error in
            guard error == nil else {
                self.donwloadState = .error("Could not download firwamre")
                return
            }
            let copyPath = URL(fileURLWithPath: NSHomeDirectory() + "/Downloads/\(self.softwareVersion.name)")
            guard (try? FileManager.default.moveItem(at: localURL!, to: copyPath )) != nil else {
                self.donwloadState = .error("Failed to move downloaded restore image to Downloads folder")
                return
            }
            self.donwloadState = self.checkSHA(path: copyPath)
        }
        
        downloadObserver = task.progress.observe(\.fractionCompleted, options: [.initial, .new]) { (progress, change) in
            self.donwloadState = .inProgress(progress.fractionCompleted)
        }
        
        task.resume()
        
    }
    
    
    func checkSHA(path: URL) -> DownloadState {
        let data = NSData(contentsOf: path)
        guard let data else {
            return .error("Could not calculate SHA1 for path: \(path)")
        }
        let hashResult = Insecure.SHA1.hash(data: data)
        let hashToString = hashResult.compactMap { String(format: "%02x", $0) }.joined()
        if hashToString != softwareVersion.firmwareSHA1 {
            return .error("SHA1 does not match!")
        }
        return .finished
    }
    
    func copyToClipboard(keyPath path: KeyPath<SoftwareVersion,String>) {
        let value = softwareVersion[keyPath: path]
        let pasteBoard = NSPasteboard.general;
        
        pasteBoard.clearContents()
        pasteBoard.setString(value, forType: .string)
        copiedState = CopiedState.fromKeyPath(path)
    }
    
    func labelViewModel(forKeyPath path: KeyPath<SoftwareVersion,String>, withTitle title: String, icon: String ) -> LabelViewModel {
        return LabelViewModel(iconName: icon, tapGestureCallback: { [unowned self] in  self.copyToClipboard(keyPath: path) }, title: title , value: softwareVersion[keyPath: path], copiedState: CopiedState.fromKeyPath(path))
    }
    
}


enum CopiedState {
    case none
    case build
    case sha
    case url
}

extension CopiedState {
    static func fromKeyPath(_ path: KeyPath<SoftwareVersion,String>) -> Self {
        return switch path {
        case \.firmwareURL:
                .url
        case \.build:
                .build
        case \.firmwareSHA1!:
                .sha
        default:
            fatalError("Cannot copy state none")
        }
    }
}
