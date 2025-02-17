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
    @Query(sort: \Plant.createdAt, order: .reverse) private var plants: [Plant]
    @StateObject private var viewModel: PlantViewModel
    @State private var showingAddPlant = false
    @State private var searchText = ""
    
    init() {
        _viewModel = StateObject(wrappedValue: PlantViewModel())
    }
    
    var filteredPlants: [Plant] {
        if searchText.isEmpty {
            return plants
        }
        return plants.filter { plant in
            plant.name.localizedCaseInsensitiveContains(searchText) ||
            plant.species.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if plants.isEmpty {
                    ContentUnavailableView(
                        "No Plants Yet",
                        systemImage: "leaf",
                        description: Text("Add your first plant to get started")
                    )
                } else {
                    List {
                        ForEach(filteredPlants) { plant in
                            NavigationLink(destination: PlantDetailView(plant: plant)) {
                                PlantCard(plant: plant)
                            }
                        }
                        .onDelete(perform: deletePlants)
                    }
                }
            }
            .navigationTitle("My Plants")
            .searchable(text: $searchText, prompt: "Search plants...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddPlant.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                if !plants.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingAddPlant) {
                AddPlantView()
            }
        }
    }
    
    private func deletePlants(at offsets: IndexSet) {
        for index in offsets {
            let plant = filteredPlants[index]
            viewModel.deletePlant(plant, modelContext: modelContext)
        }
    }
}
