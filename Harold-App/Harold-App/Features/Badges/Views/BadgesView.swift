//
//  BadgesView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI

struct BadgesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var badges: [Badge]
    @StateObject private var viewModel: BadgeViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 150), spacing: 16)
                ], spacing: 16) {
                    ForEach(badges) { badge in
                        NavigationLink(destination: BadgeDetailView(badge: badge)) {
                            BadgeCard(badge: badge)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Achievements")
        }
    }
}
