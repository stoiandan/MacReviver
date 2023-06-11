//
//  DownloadState.swift
//  MacReviver
//
//  Created by Dan Stoian on 10.06.2023.
//

import Foundation


enum DownloadState: Equatable {
    case notStarted
    case inProgress(Double)
    case finished
    case error(String)
}
