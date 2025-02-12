//
//  PlantHealthModel.swift
//  Harold-App
//
//  Created by Luke Cusato on 2/8/25.
//

import SwiftUI
import CoreML

struct PlantHealthModel {
    let model: ImageClassifierModel

    init() throws {
        self.model = try ImageClassifierModel(configuration: MLModelConfiguration())
    }
}


// Define the PlantHealthStatus struct to represent the health of a plant
struct PlantHealthStatus {
    let score: Double
    let issues: [String]
    let lastScanned: Date
    let predictions: [String]
}
