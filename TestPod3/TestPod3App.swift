//
//  TestPod3App.swift
//  TestPod3
//
//  Created by rolodestar on 2023/1/3.
//

import SwiftUI

@main
struct TestPod3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
