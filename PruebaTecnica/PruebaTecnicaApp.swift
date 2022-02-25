//
//  PruebaTecnicaApp.swift
//  PruebaTecnica
//
//  Created by Frannck Villanueva on 22/02/22.
//

import SwiftUI

@main
struct PruebaTecnicaApp: App {
    let persistenceController = PersistenceController.shared
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
