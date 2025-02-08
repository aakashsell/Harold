//
//  PlantHealthModel.swift
//  Harold-App
//
//  Created by Luke Cusato on 2/8/25.
//

import SwiftUI
import CoreML  // Import CoreML framework to use MLModel

// Define the PlantHealthModel (replace with the actual model if it exists)
struct PlantHealthModel {
    var model: MLModel              // The model is of type MLModel
    
    init(configuration: MLModelConfiguration) throws {
        // Load your actual model here, replacing 'YourModel' with the correct model name
        guard let modelURL = Bundle.main.url(forResource: "YourModel", withExtension: "mlmodelc") else {
            throw NSError(domain: "ModelError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file not found."])
        }
        self.model = try MLModel(contentsOf: modelURL, configuration: configuration)
    }
}

// Define the PlantHealthStatus struct to represent the health of a plant
struct PlantHealthStatus {
    let score: Double
    let issues: [String]
    let lastScanned: Date
    let predictions: [String]
}
