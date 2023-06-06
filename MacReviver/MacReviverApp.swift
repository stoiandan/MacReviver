//
//  MacReviverApp.swift
//  MacReviver
//
//  Created by Dan Stoian on 06.06.2023.
//

import SwiftUI
import SwiftData

@main
struct MacReviverApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
