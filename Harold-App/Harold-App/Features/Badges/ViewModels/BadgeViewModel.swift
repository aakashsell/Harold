//
//  BadgeViewModel.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Foundation
import SwiftUI
import SwiftData

class BadgeViewModel: ObservableObject {
    @Published private(set) var badges: [Badge] = []
    
    func loadBadges(modelContext: ModelContext) async {
        let descriptor = FetchDescriptor<Badge>()
        do {
            self.badges = try modelContext.fetch(descriptor)
            if badges.isEmpty {
                await initializeBadgesIfNeeded(modelContext: modelContext)
            }
        } catch {
            print("Failed to fetch badges: \(error)")
        }
    }
    
    private func initializeBadgesIfNeeded(modelContext: ModelContext) async {
        let descriptor = FetchDescriptor<Badge>()
        do {
            let existingBadges = try modelContext.fetch(descriptor)
            if existingBadges.isEmpty {
                // Initialize predefined badges
                for badge in Badge.predefinedBadges {
                    modelContext.insert(badge)
                }
                try modelContext.save()
                // Reload badges after initialization
                self.badges = try modelContext.fetch(descriptor)
            }
        } catch {
            print("Failed to initialize badges: \(error)")
        }
    }
    
    @MainActor
    func checkAndUpdateBadges(modelContext: ModelContext) async {
        do {
            // Calculate progress for each badge
            await calculatePhotoProgress(modelContext: modelContext)
            await calculateWateringProgress(modelContext: modelContext)
            await calculateHarvestProgress(modelContext: modelContext)
            await calculateHealerProgress(modelContext: modelContext)
            await calculatePropagationProgress(modelContext: modelContext)
            await calculateRepottingProgress(modelContext: modelContext)
            await calculateSeasonalProgress(modelContext: modelContext)
            await calculateRecyclingProgress(modelContext: modelContext)
            
            try modelContext.save()
            
            // Reload badges to update UI
            let descriptor = FetchDescriptor<Badge>()
            self.badges = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to update badges: \(error)")
        }
    }
    
    private func updateBadgeProgress(withName name: String, progress: Double, modelContext: ModelContext) throws {
        let descriptor = FetchDescriptor<Badge>(
            predicate: #Predicate<Badge> { badge in
                badge.name == name
            }
        )
        
        if let badge = try modelContext.fetch(descriptor).first {
            badge.progress = progress
            if progress >= 1.0 && !badge.isCompleted {
                badge.isCompleted = true
                badge.earnedAt = Date()
            }
        }
    }
    
    // Photo Master Badge
    private func calculatePhotoProgress(modelContext: ModelContext) async {
        do {
            let descriptor = FetchDescriptor<Plant>()
            let plants = try modelContext.fetch(descriptor)
            let totalPhotos = plants.reduce(0) { $0 + $1.images.count }
            let progress = Double(min(totalPhotos, 10)) / 10.0 // Need 10 photos
            try updateBadgeProgress(withName: "Photo Master", progress: progress, modelContext: modelContext)
        } catch {
            print("Failed to calculate photo progress: \(error)")
        }
    }
    
    // Watering Pro Badge
    private func calculateWateringProgress(modelContext: ModelContext) async {
        do {
            var descriptor = FetchDescriptor<CareEvent>()
            descriptor.predicate = #Predicate<CareEvent> { event in
                event.type == .water
            }
            let wateringEvents = try modelContext.fetch(descriptor)
            let progress = Double(min(wateringEvents.count, 20)) / 20.0 // Need 20 watering events
            try updateBadgeProgress(withName: "Watering Pro", progress: progress, modelContext: modelContext)
        } catch {
            print("Failed to calculate watering progress: \(error)")
        }
    }
    
    // First Harvest Badge
    private func calculateHarvestProgress(modelContext: ModelContext) async {
        do {
            var descriptor = FetchDescriptor<CareEvent>()
            descriptor.predicate = #Predicate<CareEvent> { event in
                event.type == .harvest
            }
            let harvestEvents = try modelContext.fetch(descriptor)
            let progress = harvestEvents.isEmpty ? 0.0 : 1.0 // Just need one harvest
            try updateBadgeProgress(withName: "First Harvest", progress: progress, modelContext: modelContext)
        } catch {
            print("Failed to calculate harvest progress: \(error)")
        }
    }
    
    // Plant Healer Badge
    private func calculateHealerProgress(modelContext: ModelContext) async {
        do {
            let descriptor = FetchDescriptor<DiaryEntry>()
            let entries = try modelContext.fetch(descriptor)
            
            let entriesByPlant = Dictionary(grouping: entries) { $0.plant?.id ?? "" }
            var hasHealedPlant = false
            
            for plantEntries in entriesByPlant.values {
                let sortedEntries = plantEntries.sorted { $0.timestamp < $1.timestamp }
                for i in 0..<sortedEntries.count - 1 {
                    if sortedEntries[i].healthScore < 50 && sortedEntries[i + 1].healthScore > 80 {
                        hasHealedPlant = true
                        break
                    }
                }
                if hasHealedPlant { break }
            }
            
            try updateBadgeProgress(withName: "Plant Healer", progress: hasHealedPlant ? 1.0 : 0.0, modelContext: modelContext)
        } catch {
            print("Failed to calculate healer progress: \(error)")
        }
    }
    
    // Propagation Expert Badge
    private func calculatePropagationProgress(modelContext: ModelContext) async {
        do {
            let descriptor = FetchDescriptor<CareEvent>()
            let events = try modelContext.fetch(descriptor)
            
            let propagationEvents = events.filter { event in
                guard let notes = event.notes?.lowercased() else { return false }
                return notes.contains("propagat")
            }
            
            let progress = Double(min(propagationEvents.count, 3)) / 3.0 // Need 3 propagations
            try updateBadgeProgress(withName: "Propagation Expert", progress: progress, modelContext: modelContext)
        } catch {
            print("Failed to calculate propagation progress: \(error)")
        }
    }
    
    // Repotting Master Badge
    private func calculateRepottingProgress(modelContext: ModelContext) async {
        do {
            var descriptor = FetchDescriptor<CareEvent>()
            descriptor.predicate = #Predicate<CareEvent> { event in
                event.type == .repot
            }
            let repotEvents = try modelContext.fetch(descriptor)
            let progress = Double(min(repotEvents.count, 5)) / 5.0 // Need 5 repotting events
            try updateBadgeProgress(withName: "Repotting Master", progress: progress, modelContext: modelContext)
        } catch {
            print("Failed to calculate repotting progress: \(error)")
        }
    }
    
    // Four Seasons Badge
    private func calculateSeasonalProgress(modelContext: ModelContext) async {
        do {
            let descriptor = FetchDescriptor<CareEvent>()
            let events = try modelContext.fetch(descriptor)
            
            let calendar = Calendar.current
            let months = Set(events.map { calendar.component(.month, from: $0.timestamp) })
            let seasons = Set(months.map { month -> String in
                switch month {
                case 12, 1, 2: return "Winter"
                case 3, 4, 5: return "Spring"
                case 6, 7, 8: return "Summer"
                case 9, 10, 11: return "Fall"
                default: return ""
                }
            })
            
            let progress = Double(seasons.count) / 4.0 // Need all 4 seasons
            try updateBadgeProgress(withName: "Four Seasons", progress: progress, modelContext: modelContext)
        } catch {
            print("Failed to calculate seasonal progress: \(error)")
        }
    }
    
    // Eco Gardener Badge
    private func calculateRecyclingProgress(modelContext: ModelContext) async {
        do {
            let descriptor = FetchDescriptor<CareEvent>()
            let events = try modelContext.fetch(descriptor)
            
            let recyclingEvents = events.filter { event in
                guard let notes = event.notes?.lowercased() else { return false }
                return notes.contains("recycl") || notes.contains("reuse") || notes.contains("upcycl")
            }
            
            let progress = Double(min(recyclingEvents.count, 3)) / 3.0 // Need 3 recycling events
            try updateBadgeProgress(withName: "Eco Gardener", progress: progress, modelContext: modelContext)
        } catch {
            print("Failed to calculate recycling progress: \(error)")
        }
    }
}

// Extension for Badge predefined badges
extension Badge {
    static let predefinedBadges: [Badge] = [
        Badge(name: "Photo Master",
             desc: "Upload 10 plant photos",
             category: .care),
        Badge(name: "Watering Pro",
             desc: "Water your plants 20 times",
             category: .care),
        Badge(name: "First Harvest",
             desc: "Harvest from your first plant",
             category: .harvest),
        Badge(name: "Plant Healer",
             desc: "Nurse a sick plant back to health",
             category: .care),
        Badge(name: "Propagation Expert",
             desc: "Successfully propagate 3 plants",
             category: .care),
        Badge(name: "Repotting Master",
             desc: "Repot 5 plants successfully",
             category: .care),
        Badge(name: "Four Seasons",
             desc: "Care for plants through all seasons",
             category: .seasonal),
        Badge(name: "Eco Gardener",
             desc: "Use recycled materials 3 times",
             category: .special)
    ]
}
