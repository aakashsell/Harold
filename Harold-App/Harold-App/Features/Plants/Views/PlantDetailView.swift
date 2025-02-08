
import SwiftUI
import PhotosUI

struct PlantDetailView: View {
    let plant: Plant
    @Environment(\.modelContext) private var modelContext
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showingCareSheet = false
    @State private var showingDiaryEntry = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                PhotoGalleryView(plant: plant, selectedPhotoItem: $selectedPhotoItem)
                HealthStatusView(plant: plant)
                CareHistoryView(plant: plant, showingCareSheet: $showingCareSheet)
                PlantDiaryView(plant: plant, showingDiaryEntry: $showingDiaryEntry)
            }
        }
        .navigationTitle(plant.name)
        .onChange(of: selectedPhotoItem) {
            Task {
                await addPhoto()
            }
        }
        .sheet(isPresented: $showingCareSheet) {
            AddCareEventView(plant: plant)              // Error msg: "Argument passed to call that takes no arguments"
        }
        .sheet(isPresented: $showingDiaryEntry) {
            AddDiaryEntryView(plant: plant)             // Error msg: "Argument passed to call that takes no arguments"
        }
    }

    private func addPhoto() async {
        guard let photoItem = selectedPhotoItem else { return }
        guard let imageData = try? await photoItem.loadTransferable(type: Data.self) else { return }
        
        let plantImage = PlantImage(id: UUID().uuidString,
                                  imageData: imageData,
                                  timestamp: Date())
        plantImage.plant = plant
        plant.images.append(plantImage)
        
        try? modelContext.save()
        
    }
}

struct PhotoGalleryView: View {
    let plant: Plant
    @Binding var selectedPhotoItem: PhotosPickerItem?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(plant.images, id: \.id) { image in
                    Image(uiImage: UIImage(data: image.imageData) ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 280, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .frame(width: 280, height: 200)
                        .overlay {
                            Image(systemName: "plus.circle")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

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
