//
//  PlantHealth.swift
//  Harold-App
//
//  Created by Luke Cusato on 2/8/25.
//

import SwiftUI

struct PlantHealth {
    let score: Double
    let issues: [String]  // List of issues, for example "yellow leaves", "wilting"
    let lastScanned: Date
    let predictions: [String]  // Possible predictions, for example ["Healthy", "Unhealthy"]
}
