//
//import SwiftUI
//
//struct PlantDetailView: View {
//    let plant: Plant
//    @Environment(\.modelContext) private var modelContext
//    @State private var showingCareSheet = false
//    @State private var showingDiaryEntry = false
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Photo Gallery
//                PhotoGalleryView(plant: plant)
//                
//                // Health Status
//                HealthStatusView(plant: plant)
//                
//                // Care History
//                CareHistoryView(plant: plant, showingCareSheet: $showingCareSheet)
//                
//                // Plant Diary
//                PlantDiaryView(plant: plant, showingDiaryEntry: $showingDiaryEntry)
//            }
//            .padding(.vertical)
//        }
//        .navigationTitle(plant.name)
//        .sheet(isPresented: $showingCareSheet) {
//            AddCareEventView(plant: plant)
//        }
//        .sheet(isPresented: $showingDiaryEntry) {
//            AddDiaryEntryView(plant: plant)
//        }
//    }
//}
//
//// MARK: - Photo Gallery View
//struct PhotoGalleryView: View {
//    let plant: Plant
//    
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            LazyHStack(spacing: 12) {
//                ForEach(plant.images, id: \.id) { image in
//                    Image(uiImage: UIImage(data: image.imageData) ?? UIImage())
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 280, height: 200)
//                        .clipShape(RoundedRectangle(cornerRadius: 12))
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//}
//
//// MARK: - Health Status View
//struct HealthStatusView: View {
//    let plant: Plant
//    
//    var body: some View {
//        VStack(spacing: 12) {
//            HStack {
//                Text("Plant Health")
//                    .font(.headline)
//                Spacer()
//                Text("\(Int(plant.healthScore))%")
//                    .font(.title2)
//                    .foregroundColor(Color.healthColor(score: plant.healthScore))
//            }
//            
//            ProgressView(value: plant.healthScore, total: 100)
//                .tint(Color.healthColor(score: plant.healthScore))
//        }
//        .padding()
//        .background(Color.haroldBackground)
//        .cornerRadius(12)
//        .padding(.horizontal)
//    }
//}
//
//// MARK: - Care History View
//struct CareHistoryView: View {
//    let plant: Plant
//    @Binding var showingCareSheet: Bool
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack {
//                Text("Care History")
//                    .font(.headline)
//                Spacer()
//                Button("Add Care Event") {
//                    showingCareSheet = true
//                }
//            }
//            
//            ForEach(plant.careEvents.sorted { $0.timestamp > $1.timestamp }) { event in
//                HStack {
//                    Image(systemName: careEventIcon(for: event.type))
//                        .foregroundColor(careEventColor(for: event.type))
//                    
//                    VStack(alignment: .leading) {
//                        Text(event.type.rawValue.capitalized)
//                            .font(.subheadline)
//                        if let notes = event.notes {
//                            Text(notes)
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                    
//                    Spacer()
//                    
//                    Text(event.timestamp.formattedRelativeTime)
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//                .padding(.vertical, 4)
//            }
//        }
//        .padding()
//        .background(Color.haroldBackground)
//        .cornerRadius(12)
//        .padding(.horizontal)
//    }
//    
//    private func careEventIcon(for type: CareEvent.CareType) -> String {
//        switch type {
//        case .water: return "drop.fill"
//        case .fertilize: return "leaf.fill"
//        case .prune: return "scissors"
//        case .repot: return "arrow.up.forward"
//        case .harvest: return "basket.fill"
//        }
//    }
//    
//    private func careEventColor(for type: CareEvent.CareType) -> Color {
//        switch type {
//        case .water: return .blue
//        case .fertilize: return .green
//        case .prune: return .orange
//        case .repot: return .brown
//        case .harvest: return .purple
//        }
//    }
//}
//
//// MARK: - Plant Diary View
//struct PlantDiaryView: View {
//    let plant: Plant
//    @Binding var showingDiaryEntry: Bool
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack {
//                Text("Plant Diary")
//                    .font(.headline)
//                Spacer()
//                Button("Add Entry") {
//                    showingDiaryEntry = true
//                }
//            }
//            
//            ForEach(plant.diaryEntries.sorted { $0.timestamp > $1.timestamp }) { entry in
//                VStack(alignment: .leading, spacing: 8) {
//                    HStack {
//                        Text(entry.timestamp.formattedDate)
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                        Spacer()
//                        Text("Health: \(Int(entry.healthScore))%")
//                            .font(.caption)
//                            .foregroundColor(Color.healthColor(score: entry.healthScore))
//                    }
//                    
//                    Text(entry.note)
//                        .font(.subheadline)
//                }
//                .padding()
//                .background(Color.secondary.opacity(0.1))
//                .cornerRadius(8)
//            }
//        }
//        .padding()
//        .background(Color.haroldBackground)
//        .cornerRadius(12)
//        .padding(.horizontal)
//    }
//}
//import Foundation
//import SwiftUI
//
//struct PlantDetailView: View {
//    let plant: Plant
//    @Environment(\.modelContext) private var modelContext
//    @State private var showingCareSheet = false
//    @State private var showingDiaryEntry = false
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Main Image
//                if let mainImageData = plant.mainImageData,
//                   let uiImage = UIImage(data: mainImageData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(height: 200)
//                        .clipShape(RoundedRectangle(cornerRadius: 12))
//                        .padding(.horizontal)
//                } else {
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(Color.gray.opacity(0.2))
//                        .frame(height: 200)
//                        .overlay {
//                            Image(systemName: "leaf.fill")
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.horizontal)
//                }
//                
//                // Health Status
//                HealthStatusView(plant: plant)          // Error msg: "Cannot find 'HealthStatusView' in scope"
//
//                
//                // Care History
//                CareHistoryView(plant: plant, showingCareSheet: $showingCareSheet)          // Error msg: "Cannot find 'CareHistoryView' in scope"
//
//                
//                // Plant Diary
//                PlantDiaryView(plant: plant, showingDiaryEntry: $showingDiaryEntry)         // Error msg: "Cannot find 'PlantDiaryView' in scope"
//
//            }
//            .padding(.vertical)
//        }
//        .navigationTitle(plant.name)
//        .sheet(isPresented: $showingCareSheet) {
//            AddCareEventView(plant: plant)
//        }
//        .sheet(isPresented: $showingDiaryEntry) {
//            AddDiaryEntryView(plant: plant)
//        }
//    }
//}
import SwiftUI
import SwiftData

struct PlantDetailView: View {
    let plant: Plant
    @Environment(\.modelContext) private var modelContext
    @State private var showingCareSheet = false
    @State private var showingDiaryEntry = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Main Image
                if let mainImageData = plant.mainImageData,
                   let uiImage = UIImage(data: mainImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                }
                
                // Health Status
                HealthStatusView(plant: plant)
                
                // Care History
                CareHistoryView(plant: plant, showingCareSheet: $showingCareSheet)
                
                // Plant Diary
                PlantDiaryView(plant: plant, showingDiaryEntry: $showingDiaryEntry)
            }
            .padding(.vertical)
        }
        .navigationTitle(plant.name)
        .sheet(isPresented: $showingCareSheet) {
            AddCareEventView(plant: plant)
        }
        .sheet(isPresented: $showingDiaryEntry) {
            AddDiaryEntryView(plant: plant)
        }
    }
}

// MARK: - Health Status View
struct HealthStatusView: View {
    let plant: Plant
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Plant Health")
                    .font(.headline)
                Spacer()
                Text("\(Int(plant.healthScore))%")
                    .font(.title2)
                    .foregroundColor(Color.healthColor(score: plant.healthScore))
            }
            
            ProgressView(value: plant.healthScore, total: 100)
                .tint(Color.healthColor(score: plant.healthScore))
        }
        .padding()
        .background(Color.haroldBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Care History View
struct CareHistoryView: View {
    let plant: Plant
    @Binding var showingCareSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Care History")
                    .font(.headline)
                Spacer()
                Button("Add Care Event") {
                    showingCareSheet = true
                }
            }
            
            ForEach(plant.careEvents.sorted { $0.timestamp > $1.timestamp }) { event in
                HStack {
                    Image(systemName: careEventIcon(for: event.type))
                        .foregroundColor(careEventColor(for: event.type))
                    
                    VStack(alignment: .leading) {
                        Text(event.type.rawValue.capitalized)
                            .font(.subheadline)
                        if let notes = event.notes {
                            Text(notes)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Text(event.timestamp.formattedRelativeTime)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color.haroldBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func careEventIcon(for type: CareEvent.CareType) -> String {
        switch type {
        case .water: return "drop.fill"
        case .fertilize: return "leaf.fill"
        case .prune: return "scissors"
        case .repot: return "arrow.up.forward"
        case .harvest: return "basket.fill"
        }
    }
    
    private func careEventColor(for type: CareEvent.CareType) -> Color {
        switch type {
        case .water: return .blue
        case .fertilize: return .green
        case .prune: return .orange
        case .repot: return .brown
        case .harvest: return .purple
        }
    }
}

// MARK: - Plant Diary View
struct PlantDiaryView: View {
    let plant: Plant
    @Binding var showingDiaryEntry: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Plant Diary")
                    .font(.headline)
                Spacer()
                Button("Add Entry") {
                    showingDiaryEntry = true
                }
            }
            
            ForEach(plant.diaryEntries.sorted { $0.timestamp > $1.timestamp }) { entry in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(entry.timestamp.formattedDate)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Health: \(Int(entry.healthScore))%")
                            .font(.caption)
                            .foregroundColor(Color.healthColor(score: entry.healthScore))
                    }
                    
                    Text(entry.note)
                        .font(.subheadline)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.haroldBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
