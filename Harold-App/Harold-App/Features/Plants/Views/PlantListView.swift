//
//  PlantListView.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftUI
import SwiftData

struct PlantListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var plants: [Plant]
    @StateObject private var viewModel = PlantViewModel()
    @State private var showingAddPlant = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(plants) { plant in
                    NavigationLink(destination: PlantDetailView(plant: plant)) {
                        PlantCard(plant: plant)
                    }
                }
                .onDelete(perform: deletePlants)
            }
            .navigationTitle("My Plants")
            .toolbar {
                Button("Add Plant") {
                    showingAddPlant.toggle()
                }
            }
            .sheet(isPresented: $showingAddPlant) {
                AddPlantView()
            }
        }
    }
    
    private func deletePlants(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(plants[index])
        }
    }
}
