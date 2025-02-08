//
//  PlantHealthClassifier.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Vision
import CoreML

class PlantHealthClassifier {
    static let shared = PlantHealthClassifier()
    private var model: VNCoreMLModel?
    
    private init() {
        do {
            let config = MLModelConfiguration()
            let plantHealth = try PlantHealthModel(configuration: config)  // Ensure PlantHealthModel is the correct ML model class
            model = try VNCoreMLModel(for: plantHealth.model)
        } catch {
            print("Failed to load ML model: \(error)")
        }
    }
    
    func classifyPlantHealth(_ image: CGImage) async throws -> PlantHealthStatus { // Change PlantHealth to PlantHealthStatus
        guard let model = model else {
            throw MLError.modelNotLoaded
        }
        
        let request = VNCoreMLRequest(model: model)
        let handler = VNImageRequestHandler(cgImage: image)
        try handler.perform([request])
        
        guard let results = request.results as? [VNClassificationObservation],
              let topResult = results.first else {
            throw MLError.noResults
        }
        
        return PlantHealthStatus( // Change PlantHealth to PlantHealthStatus
            score: Double(topResult.confidence) * 100,
            issues: [],
            lastScanned: Date(),
            predictions: []
        )
    }
    
    enum MLError: Error {
        case modelNotLoaded
        case noResults
    }
}
