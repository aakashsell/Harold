//
//  PlantHealthClassifier.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Vision
import CoreML

struct PlantHealthClassifier {
    static let shared = PlantHealthClassifier()

    private let model: VNCoreMLModel

    private init() {
        do {
            let coreMLModel = try ImageClassifierModel(configuration: MLModelConfiguration()).model
            self.model = try VNCoreMLModel(for: coreMLModel)
        } catch {
            fatalError("Failed to load CoreML model: \(error)")
        }
    }

    func classifyPlantHealth(from image: CGImage) async throws -> PlantHealthStatus {
        let request = VNCoreMLRequest(model: model)
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        try handler.perform([request])
        
        guard let results = request.results as? [VNClassificationObservation],
              let topResult = results.first else {
            throw MLError.noResults
        }
        
        let issues = results.filter { $0.confidence > 0.2 && $0.identifier != "Healthy" }
                             .map { $0.identifier }
        
        return PlantHealthStatus(
            score: Double(topResult.confidence) * 100,
            issues: issues,
            lastScanned: Date(),
            predictions: results.map { $0.identifier }
        )
    }
}
