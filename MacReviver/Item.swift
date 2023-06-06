//
//  Item.swift
//  MacReviver
//
//  Created by Dan Stoian on 06.06.2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
