//
//  BadgeViewModel.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Foundation
import SwiftData

class BadgeViewModel: ObservableObject {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        Task {
            await initializeBadgesIfNeeded()
        }
    }
    
    private func initializeBadgesIfNeeded() async {
        let descriptor = FetchDescriptor<Badge>()
        
        do {
            let existingBadges = try modelContext.fetch(descriptor)
            if existingBadges.isEmpty {
                // Initialize predefined badges
                for badge in Self.predefinedBadges {
                    modelContext.insert(badge)
                }
                try modelContext.save()
            }
        } catch {
            print("Failed to initialize badges: \(error)")
        }
    }
    
    static let predefinedBadges: [Badge] = [
        Badge(name: "Photo Enthusiast",
             desc: "Upload 20 plant photos",
             category: .care),
        Badge(name: "Growth Expert",
             desc: "Graduate from 5+ pot sizes",
             category: .care),
        Badge(name: "Propagator",
             desc: "Propagate an existing plant",
             category: .special),
        Badge(name: "Four Seasons",
             desc: "Care for a plant through all four seasons",
             category: .seasonal),
        Badge(name: "Watering Wizard",
             desc: "Explored 3 methods of watering",
             category: .care),
        Badge(name: "Thrifty Gardener",
             desc: "Saved $100 on produce",
             category: .harvest),
        Badge(name: "Companion Master",
             desc: "10 pairs of companion plants",
             category: .learning),
        Badge(name: "Rainbow Harvest",
             desc: "ROYGBIV of produce",
             category: .harvest),
        Badge(name: "Fruit Expert",
             desc: "Harvested 10 fruits",
             category: .harvest),
        Badge(name: "Veggie Virtuoso",
             desc: "Harvested 10 servings of vegetables",
             category: .harvest),
        Badge(name: "Global Gardener",
             desc: "Grown plants from 5 different continents",
             category: .special),
        Badge(name: "Plant Healer",
             desc: "Successfully revived a struggling plant",
             category: .care),
        Badge(name: "Sustainable Harvest",
             desc: "Produced a continuous harvest for 3+ months",
             category: .harvest),
        Badge(name: "Exotic Explorer",
             desc: "Grew a rare plant not common in your region",
             category: .special),
        Badge(name: "Eco Gardener",
             desc: "Used recycled goods as plant supplies",
             category: .special)
    ]
    
    func checkAndUpdateBadges() async {
        do {
            let descriptor = FetchDescriptor<Badge>()
            let badges = try modelContext.fetch(descriptor)
            
            for badge in badges {
                let progress = try await calculateProgress(for: badge)
                badge.progress = progress
                
                if progress >= 1.0 && !badge.isCompleted {
                    badge.isCompleted = true
                    badge.earnedAt = Date()
                }
            }
            
            try modelContext.save()
        } catch {
            print("Failed to update badges: \(error)")
        }
    }
    
    private func calculateProgress(for badge: Badge) async throws -> Double {
        switch badge.name {
        case "Photo Enthusiast":
            return try await calculatePhotoProgress()
        case "Growth Expert":
            return try await calculatePotSizeProgress()
        case "Four Seasons":
            return try await calculateSeasonalProgress()
        case "Watering Wizard":
            return try await calculateWateringMethodsProgress()
        case "Thrifty Gardener":
            return try await calculateSavingsProgress()
        case "Rainbow Harvest":
            return try await calculateColorProgress()
        case "Fruit Expert":
            return try await calculateFruitProgress()
        case "Veggie Virtuoso":
            return try await calculateVeggieProgress()
        case "Sustainable Harvest":
            return try await calculateContinuousHarvestProgress()
        default:
            return 0.0
        }
    }
    
    private func calculatePhotoProgress() async throws -> Double {
        let descriptor = FetchDescriptor<Plant>()
        let plants = try modelContext.fetch(descriptor)
        let totalPhotos = plants.reduce(0) { $0 + $1.images.count }
        return Double(min(totalPhotos, 20)) / 20.0
    }
    
    private func calculatePotSizeProgress() async throws -> Double {
        var descriptor = FetchDescriptor<CareEvent>()
        descriptor.predicate = #Predicate<CareEvent> { event in
            event.type == .repot
        }
        let repotEvents = try modelContext.fetch(descriptor)
        let uniquePlants = Set(repotEvents.compactMap { $0.plant?.id })
        return Double(min(uniquePlants.count, 5)) / 5.0
    }
    
    private func calculateSeasonalProgress() async throws -> Double {
        // Implementation for tracking plant care across seasons
        // This would need to check care events across different months
        let descriptor = FetchDescriptor<CareEvent>()
        let events = try modelContext.fetch(descriptor)
        
        let calendar = Calendar.current
        let seasonMonths = Dictionary(grouping: events) { event in
            calendar.component(.month, from: event.timestamp)
        }
        
        // Count unique seasons (Winter: 12-2, Spring: 3-5, Summer: 6-8, Fall: 9-11)
        let seasons = Set(seasonMonths.keys.map { month in
            switch month {
            case 12, 1, 2: return "Winter"
            case 3, 4, 5: return "Spring"
            case 6, 7, 8: return "Summer"
            case 9, 10, 11: return "Fall"
            default: return ""
            }
        })
        
        return Double(seasons.count) / 4.0
    }
    
    private func calculateWateringMethodsProgress() async throws -> Double {
        var descriptor = FetchDescriptor<CareEvent>()
        descriptor.predicate = #Predicate<CareEvent> { event in
            event.type == .water
        }
        let wateringEvents = try modelContext.fetch(descriptor)
        
        // Check notes for different watering methods mentioned
        let methods = Set(wateringEvents.compactMap { event -> String? in
            guard let notes = event.notes?.lowercased() else { return nil }
            if notes.contains("mist") || notes.contains("spray") {
                return "misting"
            } else if notes.contains("bottom") || notes.contains("soak") {
                return "bottom_watering"
            } else if notes.contains("drip") {
                return "drip"
            } else if notes.contains("self") || notes.contains("wick") {
                return "self_watering"
            }
            return "traditional"
        })
        
        return Double(min(methods.count, 3)) / 3.0
    }
    
    private func calculateSavingsProgress() async throws -> Double {
        var descriptor = FetchDescriptor<CareEvent>()
        descriptor.predicate = #Predicate<CareEvent> { event in
            event.type == .harvest
        }
        let harvestEvents = try modelContext.fetch(descriptor)
        
        // Calculate estimated savings (this would need to be enhanced with actual produce prices)
        let estimatedSavings = harvestEvents.reduce(0.0) { total, event in
            // Basic estimation - could be improved with more detailed tracking
            total + 5.0 // Assuming average $5 savings per harvest
        }
        
        return min(estimatedSavings / 100.0, 1.0)
    }
    
    private func calculateColorProgress() async throws -> Double {
        let descriptor = FetchDescriptor<Plant>()
        let plants = try modelContext.fetch(descriptor)
        
        // Track colors found in harvested produce
        var colors: Set<String> = []
        
        for plant in plants {
            let harvestEvents = plant.careEvents.filter { $0.type == .harvest }
            if !harvestEvents.isEmpty {
                // This would need to be enhanced with actual produce color tracking
                if plant.species.lowercased().contains("tomato") {
                    colors.insert("red")
                } else if plant.species.lowercased().contains("carrot") {
                    colors.insert("orange")
                } else if plant.species.lowercased().contains("corn") {
                    colors.insert("yellow")
                } else if plant.species.lowercased().contains("lettuce") {
                    colors.insert("green")
                } else if plant.species.lowercased().contains("blueberry") {
                    colors.insert("blue")
                } else if plant.species.lowercased().contains("eggplant") {
                    colors.insert("violet")
                }
            }
        }
        
        return Double(colors.count) / 7.0 // ROYGBIV = 7 colors
    }
    
    private func calculateFruitProgress() async throws -> Double {
        var descriptor = FetchDescriptor<CareEvent>()
        descriptor.predicate = #Predicate<CareEvent> { event in
            event.type == .harvest
        }
        let harvestEvents = try modelContext.fetch(descriptor)
        
        let fruitHarvests = harvestEvents.filter { event in
            guard let plant = event.plant else { return false }
            // This would need a more comprehensive list of fruits
            return plant.species.lowercased().contains("tomato") ||
                   plant.species.lowercased().contains("apple") ||
                   plant.species.lowercased().contains("berry") ||
                   plant.species.lowercased().contains("melon")
        }
        
        return Double(min(fruitHarvests.count, 10)) / 10.0
    }
    
    private func calculateVeggieProgress() async throws -> Double {
        var descriptor = FetchDescriptor<CareEvent>()
        descriptor.predicate = #Predicate<CareEvent> { event in
            event.type == .harvest
        }
        let harvestEvents = try modelContext.fetch(descriptor)
        
        let veggieHarvests = harvestEvents.filter { event in
            guard let plant = event.plant else { return false }
            // This would need a more comprehensive list of vegetables
            return plant.species.lowercased().contains("lettuce") ||
                   plant.species.lowercased().contains("carrot") ||
                   plant.species.lowercased().contains("pepper") ||
                   plant.species.lowercased().contains("cucumber")
        }
        
        return Double(min(veggieHarvests.count, 10)) / 10.0
    }
    
    private func calculateContinuousHarvestProgress() async throws -> Double {
        var descriptor = FetchDescriptor<CareEvent>()
        descriptor.predicate = #Predicate<CareEvent> { event in
            event.type == .harvest
        }
        let harvestEvents = try modelContext.fetch(descriptor)
        
        // Sort events by timestamp
        let sortedEvents = harvestEvents.sorted { $0.timestamp < $1.timestamp }
        
        var longestStreak = 0
        var currentStreak = 0
        var lastHarvestDate: Date?
        
        for event in sortedEvents {
            if let last = lastHarvestDate {
                let calendar = Calendar.current
                let daysBetween = calendar.dateComponents([.day], from: last, to: event.timestamp).day ?? 0
                
                if daysBetween <= 30 { // Allowing up to 30 days between harvests
                    currentStreak += 1
                    longestStreak = max(longestStreak, currentStreak)
                } else {
                    currentStreak = 1
                }
            } else {
                currentStreak = 1
            }
            lastHarvestDate = event.timestamp
        }
        
        // Convert to months (roughly)
        let monthsOfContinuousHarvest = Double(longestStreak) / 30.0
        return min(monthsOfContinuousHarvest / 3.0, 1.0)
    }
    
    private func calculateGlobalPlantsProgress() async throws -> Double {
        let descriptor = FetchDescriptor<Plant>()
        let plants = try modelContext.fetch(descriptor)
        
        // This would need a proper database of plant origins
        var continents: Set<String> = []
        
        for plant in plants {
            if plant.species.lowercased().contains("aloe") {
                continents.insert("Africa")
            } else if plant.species.lowercased().contains("monstera") {
                continents.insert("South America")
            } else if plant.species.lowercased().contains("orchid") {
                continents.insert("Asia")
            } else if plant.species.lowercased().contains("lavender") {
                continents.insert("Europe")
            } else if plant.species.lowercased().contains("eucalyptus") {
                continents.insert("Australia")
            }
        }
        
        return Double(continents.count) / 5.0
    }
    
    private func calculatePlantHealerProgress() async throws -> Double {
        let descriptor = FetchDescriptor<DiaryEntry>()
        let entries = try modelContext.fetch(descriptor)
        
        // Look for plants that recovered from poor health
        var healedPlants: Set<String> = []
        
        // Group entries by plant
        let entriesByPlant = Dictionary(grouping: entries) { $0.plant?.id ?? "" }
        
        for (plantId, plantEntries) in entriesByPlant {
            let sortedEntries = plantEntries.sorted { $0.timestamp < $1.timestamp }
            
            // Look for patterns of low health followed by high health
            for i in 0..<sortedEntries.count - 1 {
                if sortedEntries[i].healthScore < 50 && sortedEntries[i + 1].healthScore > 80 {
                    healedPlants.insert(plantId)
                    break
                }
            }
        }
        
        return healedPlants.isEmpty ? 0.0 : 1.0
    }
    
    private func calculateRecycledSuppliesProgress() async throws -> Double {
        // This would need to be enhanced with actual tracking of recycled materials
        // For now, we'll assume basic tracking through care event notes
        
        let descriptor = FetchDescriptor<CareEvent>()
        let events = try modelContext.fetch(descriptor)
        
        let recycledEvents = events.filter { event in
            guard let notes = event.notes?.lowercased() else { return false }
            return notes.contains("recycled") ||
                   notes.contains("reused") ||
                   notes.contains("upcycled")
        }
        
        return recycledEvents.isEmpty ? 0.0 : 1.0
    }
}
