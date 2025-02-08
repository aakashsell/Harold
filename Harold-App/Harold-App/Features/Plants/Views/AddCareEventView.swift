//
//  AddCareEventView.swift
//  Harold-App
//
//  Created by Luke Cusato on 2/8/25.
//

import SwiftUI

struct AddCareEventView: View {
    let plant: Plant
    
    var body: some View {
        // Your view content for adding care event here
        Text("Add Care Event for \(plant.name)")
            .padding()
    }
}

//#Preview {
//    AddCareEventView()
//}
