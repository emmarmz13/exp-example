//
//  Example_AppApp.swift
//  Example App
//
//  Created by Emmanuel Ramírez on 12/01/25.
//

import SwiftUI

@main
struct Example_AppApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
