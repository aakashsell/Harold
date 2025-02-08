//
//  ContentView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .plants
    
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
            
//            BadgesView()
//                .tabItem {
//                    Label("Badges", systemImage: "star.fill")
//                }
//                .tag(Tab.badges)
//            
//            LearningView()
//                .tabItem {
//                    Label("Learn", systemImage: "book.fill")
//                }
//                .tag(Tab.learning)
        }
    }
}
