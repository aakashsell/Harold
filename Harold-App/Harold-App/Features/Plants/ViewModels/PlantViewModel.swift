//
//  PlantViewModel.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

@Observable
class PlantViewModel: ObservableObject {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func deletePlant(_ plant: Plant) {
        modelContext.delete(plant)
        try? modelContext.save()
    }
    
    func updatePlantHealth(_ plant: Plant, score: Double) {
        plant.healthScore = score
        plant.updatedAt = Date()
        try? modelContext.save()
    }
}
