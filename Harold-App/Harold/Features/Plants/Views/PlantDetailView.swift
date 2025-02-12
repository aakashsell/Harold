//
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
