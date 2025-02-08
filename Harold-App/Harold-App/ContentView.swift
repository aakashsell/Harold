//
//  ContentView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab: Tab = .plants
    
    enum Tab {
        case plants, learning, chat
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PlantListView()
                .tabItem {
                    Label("Plants", systemImage: "leaf.fill")
                }
                .tag(Tab.plants)
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "sparkles")
                }
                .tag(Tab.chat)
            LearningView()
                .tabItem {
                    Label("Learn", systemImage: "book.fill")
                }
                .tag(Tab.learning)
        }
    }
}
