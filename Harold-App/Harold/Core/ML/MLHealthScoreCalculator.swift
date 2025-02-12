//
//  MLHealthScoreCalculator.swift
//  Harold
//
//  Created by Juan Pablo Urista on 2/12/25.
//

import Foundation
import Vision
import UIKit

class MLHealthScoreCalculator {
    static let shared = MLHealthScoreCalculator()
    private let healthClassifier = PlantHealthClassifier.shared
    
    func calculateHealthScore(from image: UIImage) async throws -> Double {
        guard let cgImage = image.cgImage else {
            throw MLError.invalidImage
        }
        
        let healthStatus = try await healthClassifier.classifyPlantHealth(from: cgImage)
        return healthStatus.score
    }
}
