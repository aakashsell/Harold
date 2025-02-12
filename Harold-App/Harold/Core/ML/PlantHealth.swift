//
//  PlantHealth.swift
//  Harold-App
//
//  Created by Luke Cusato on 2/8/25.
//

import SwiftUI
import Foundation

struct PlantHealth {
    let score: Double
    let issues: [String]
    let lastScanned: Date
    let predictions: [String]
}

enum MLError: Error {
    case noResults
    case invalidImage
    case modelInitializationFailed
}
