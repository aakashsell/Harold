//
//  BadgesView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI
import SwiftData

struct BadgesView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: BadgeViewModel
    
    // Remove @Query and use the published property from viewModel instead
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 150), spacing: 16)
                ], spacing: 16) {
                    ForEach(viewModel.badges) { badge in
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
