//
//  AddDiaryEntryView.swift
//  Harold-App
//
//  Created by Luke Cusato on 2/8/25.
//

import SwiftUI

struct AddDiaryEntryView: View {
    let plant: Plant
    
    var body: some View {
        // Your view content for adding diary entry here
        Text("Add Diary Entry for \(plant.name)")
            .padding()
    }
}

//#Preview {
//    AddDiaryEntryView()
//}
