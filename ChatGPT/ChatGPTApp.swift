//
//  ChatGPTApp.swift
//  ChatGPT
//
//  Created by Martin Richter on 16.12.22.
//

import SwiftUI

@main
struct ChatGPTApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
