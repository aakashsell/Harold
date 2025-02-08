//
//  AddDiaryEntryView.swift
//  Harold-App
//
//  Created by Luke Cusato on 2/8/25.
//
//import SwiftUI
//import SwiftData
//import PhotosUI
//
//struct AddDiaryEntryView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.dismiss) private var dismiss
//    
//    let plant: Plant
//    @State private var note: String = ""
//    @State private var healthScore: Double = 100
//    @State private var selectedPhotoItem: PhotosPickerItem?
//    @State private var imageData: Data?
//    
//    private var healthColor: Color {
//        Color.healthColor(score: healthScore)
//    }
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section("Health Score") {
//                    VStack(alignment: .leading, spacing: 8) {
//                        HStack {
//                            Text("Current Score: ")
//                            Text("\(Int(healthScore))")
//                                .foregroundColor(healthColor)
//                                .bold()
//                        }
//                        
//                        Slider(value: $healthScore, in: 0...100, step: 1) {
//                            Text("Health Score")
//                        } minimumValueLabel: {
//                            Text("0")
//                                .foregroundColor(.red)
//                        } maximumValueLabel: {
//                            Text("100")
//                                .foregroundColor(.green)
//                        }
//                        
//                        Text(healthDescription)
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                }
//                
//                Section("Add Photo") {
//                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
//                        HStack {
//                            Image(systemName: "photo")
//                            Text("Select a Photo")
//                        }
//                    }
//                    
//                    if let imageData, let uiImage = UIImage(data: imageData) {
//                        Image(uiImage: uiImage)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(height: 200)
//                            .clipShape(RoundedRectangle(cornerRadius: 8))
//                    }
//                }
//                
//                Section("Notes") {
//                    TextEditor(text: $note)
//                        .frame(minHeight: 100)
//                    
//                    if note.isEmpty {
//                        Text("Describe how your plant is doing")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                }
//                
//                Section {
//                    Button {
//                        addDiaryEntry()
//                    } label: {
//                        Text("Add Entry")
//                            .frame(maxWidth: .infinity)
//                    }
//                    .disabled(note.isEmpty)
//                }
//            }
//            .navigationTitle("Add Diary Entry")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//            }
//            .onChange(of: selectedPhotoItem) {
//                Task {
//                    if let photoItem = selectedPhotoItem,
//                       let data = try? await photoItem.loadTransferable(type: Data.self) {
//                        imageData = data
//                    }
//                }
//            }
//        }
//    }
//    
//    private var healthDescription: String {
//        switch healthScore {
//        case 90...100:
//            return "Thriving: Plant is in excellent condition"
//        case 70..<90:
//            return "Healthy: Plant is doing well"
//        case 50..<70:
//            return "Fair: Plant needs attention"
//        case 30..<50:
//            return "Poor: Plant requires immediate care"
//        default:
//            return "Critical: Plant is in serious trouble"
//        }
//    }
//    
//    private func addDiaryEntry() {
//        // Create and save the diary entry
//        let entry = DiaryEntry(
//            note: note,
//            healthScore: healthScore,
//            plant: plant
//        )
//        modelContext.insert(entry)
//        
//        // Add photo if available
//        if let imageData {
//            let plantImage = PlantImage(
//                id: UUID().uuidString,
//                imageData: imageData,
//                timestamp: Date()
//            )
//            plantImage.plant = plant
//            plant.images.append(plantImage)
//        }
//        
//        // Update plant's health score
//        plant.healthScore = healthScore
//        plant.updatedAt = Date()
//        
//        // Save changes
//        do {
//            try modelContext.save()
//            dismiss()
//        } catch {
//            print("Failed to save diary entry: \(error)")
//        }
//    }
//}
import SwiftUI
import SwiftData
import PhotosUI

struct AddDiaryEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let plant: Plant
    @State private var note: String = ""
    @State private var healthScore: Double = 100
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var replaceMainImage: Bool = false
    
    private var healthColor: Color {
        Color.healthColor(score: healthScore)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Health Score") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Current Score: ")
                            Text("\(Int(healthScore))")
                                .foregroundColor(healthColor)
                                .bold()
                        }
                        
                        Slider(value: $healthScore, in: 0...100, step: 1) {
                            Text("Health Score")
                        } minimumValueLabel: {
                            Text("0")
                                .foregroundColor(.red)
                        } maximumValueLabel: {
                            Text("100")
                                .foregroundColor(.green)
                        }
                        
                        Text(healthDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Add Photo") {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Select a Photo")
                        }
                    }
                    
                    if let imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Toggle("Set as Main Image", isOn: $replaceMainImage)
                }
                
                Section("Notes") {
                    TextEditor(text: $note)
                        .frame(minHeight: 100)
                    
                    if note.isEmpty {
                        Text("Describe how your plant is doing")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button {
                        addDiaryEntry()
                    } label: {
                        Text("Add Entry")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(note.isEmpty)
                }
            }
            .navigationTitle("Add Diary Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onChange(of: selectedPhotoItem) {
                Task {
                    if let photoItem = selectedPhotoItem,
                       let data = try? await photoItem.loadTransferable(type: Data.self) {
                        imageData = data
                    }
                }
            }
        }
    }
    
    private var healthDescription: String {
        switch healthScore {
        case 90...100:
            return "Thriving: Plant is in excellent condition"
        case 70..<90:
            return "Healthy: Plant is doing well"
        case 50..<70:
            return "Fair: Plant needs attention"
        case 30..<50:
            return "Poor: Plant requires immediate care"
        default:
            return "Critical: Plant is in serious trouble"
        }
    }
    
    private func addDiaryEntry() {
        // Create and save the diary entry
        let entry = DiaryEntry(
            note: note,
            healthScore: healthScore,
            plant: plant,
            imageData: imageData
        )
        modelContext.insert(entry)
        
        // Update plant's main image if selected
        if replaceMainImage, let imageData {
            plant.mainImageData = imageData
        }
        
        // Update plant's health score
        plant.healthScore = healthScore
        plant.updatedAt = Date()
        
        // Save changes
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save diary entry: \(error)")
        }
    }
}

