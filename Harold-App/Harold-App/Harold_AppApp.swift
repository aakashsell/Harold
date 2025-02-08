//
//  Harold_AppApp.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI
import SwiftData

@main
struct HaroldApp: App {
    @StateObject private var deviceManager = DeviceManager.shared
    let modelContainer: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                Plant.self,
                CareEvent.self,
                DiaryEntry.self,
                Badge.self,
                Lesson.self
            ])
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}

