//
//  poc_adapterApp.swift
//  poc-adapter
//
//  Created by carlos amorim on 25/07/23.
//

import SwiftUI

@main
struct poc_adapterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
