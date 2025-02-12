
import SwiftUI
import PhotosUI
import SwiftData

struct AddPlantView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var species = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var isRecycledPot = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Plant Name", text: $name)
                    TextField("Species", text: $species)
                }
                
                Section {
                    HStack {
                        Spacer()
                        if let imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            PhotosPicker(selection: $selectedPhotoItem,
                                       matching: .images) {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                                    .frame(width: 200, height: 200)
                                    .overlay {
                                        VStack {
                                            Image(systemName: "plus.circle")
                                                .font(.largeTitle)
                                            Text("Add Photo")
                                                .font(.caption)
                                        }
                                        .foregroundColor(.gray)
                                    }
                            }
                        }
                        Spacer()
                    }
                }
                
                Section {
                    Toggle("Using Recycled Pot", isOn: $isRecycledPot)
                }
                
                Section {
                    Button("Add Plant") {
                        addPlant()
                    }
                    .disabled(name.isEmpty || species.isEmpty)
                }
            }
            .navigationTitle("Add New Plant")
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
    
    private func addPlant() {
        // Create the plant with the main image
        let plant = Plant(
            id: UUID().uuidString,
            deviceId: DeviceManager.shared.deviceId,
            name: name,
            species: species,
            mainImageData: imageData, // Set the main image data
            healthScore: 100,
            createdAt: Date(),
            updatedAt: Date(),
            careEvents: [CareEvent](),
            diaryEntries: [DiaryEntry]()
        )
        
        modelContext.insert(plant)
        
        // Add recycled pot note if applicable
        if isRecycledPot {
            let event = CareEvent(
                type: .repot,
                notes: "Started with recycled pot",
                plant: plant
            )
            modelContext.insert(event)
        }
        
        // Save changes and dismiss the view
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save plant: \(error)")
        }
    }
}
