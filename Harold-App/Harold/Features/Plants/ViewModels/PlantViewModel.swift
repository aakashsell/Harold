////
////  PlantViewModel.swift
////  Harold-App
////
////  Created by Juan Pablo Urista on 2/7/25.
////
//
//import SwiftUI
//import SwiftData
//
//class PlantViewModel: ObservableObject {
//    func deletePlant(_ plant: Plant, modelContext: ModelContext) {
//        // Delete all associated images
//        for image in plant.images {             // Error msg: "Value of type 'Plant' has no member 'images'"
//
//            modelContext.delete(image)
//        }
//        
//        // Delete all care events
//        for event in plant.careEvents {
//            modelContext.delete(event)
//        }
//        
//        // Delete all diary entries
//        for entry in plant.diaryEntries {
//            modelContext.delete(entry)
//        }
//        
//        // Finally delete the plant
//        modelContext.delete(plant)
//        
//        // Save changes
//        do {
//            try modelContext.save()
//
//        } catch {
//            print("Failed to delete plant: \(error)")
//        }
//    }
//    
//    func updatePlantHealth(_ plant: Plant, newScore: Double, modelContext: ModelContext) {
//        plant.healthScore = newScore
//        plant.updatedAt = Date()
//        
//        do {
//            try modelContext.save()
//        } catch {
//            print("Failed to update plant health: \(error)")
//        }
//    }
//}
import SwiftUI
import SwiftData

class PlantViewModel: ObservableObject {
    func deletePlant(_ plant: Plant, modelContext: ModelContext) {
        // Delete all care events
        for event in plant.careEvents {
            modelContext.delete(event)
        }
        
        // Delete all diary entries
        for entry in plant.diaryEntries {
            modelContext.delete(entry)
        }
        
        // Finally delete the plant
        modelContext.delete(plant)
        
        // Save changes
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete plant: \(error)")
        }
    }
    
    func updatePlantHealth(_ plant: Plant, newScore: Double, modelContext: ModelContext) {
        plant.healthScore = newScore
        plant.updatedAt = Date()
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to update plant health: \(error)")
        }
    }
}
