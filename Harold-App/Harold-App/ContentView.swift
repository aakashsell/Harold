//
//  ContentView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab: Tab = .plants
    @Environment(\.modelContext) private var modelContext
    @StateObject private var badgeViewModel: BadgeViewModel
    
    init() {
        _badgeViewModel = StateObject(wrappedValue: BadgeViewModel())
    }
    
    enum Tab {
        case plants, badges, learning
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PlantListView()
                .tabItem {
                    Label("Plants", systemImage: "leaf.fill")
                }
                .tag(Tab.plants)
            
            BadgesView(viewModel: badgeViewModel)
                .tabItem {
                    Label("Badges", systemImage: "star.fill")
                }
                .tag(Tab.badges)
            
            LearningView()
                .tabItem {
                    Label("Learn", systemImage: "book.fill")
                }
                .tag(Tab.learning)
        }
        .onAppear {
            Task {
                await badgeViewModel.loadBadges(modelContext: modelContext)
            }
        }
    }
}
