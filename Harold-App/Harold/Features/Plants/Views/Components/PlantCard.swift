import SwiftUI

struct PlantCard: View {
    let plant: Plant
    
    var body: some View {
        HStack(spacing: 16) {
            // Plant Image
            if let mainImageData = plant.mainImageData,
               let uiImage = UIImage(data: mainImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.gray)
                    }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(plant.name)
                    .font(.headline)
                
                Text(plant.species)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Health indicator
                HStack {
                    Circle()
                        .fill(Color.healthColor(score: plant.healthScore))
                        .frame(width: 12, height: 12)
                    
                    Text("\(Int(plant.healthScore))% Health")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Last watered indicator
            if let lastWatering = plant.careEvents.first(where: { $0.timestamp > Date().addingTimeInterval(-86400) }) {
                VStack {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.blue)
                    Text(lastWatering.timestamp.formattedRelativeTime)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.haroldBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}
