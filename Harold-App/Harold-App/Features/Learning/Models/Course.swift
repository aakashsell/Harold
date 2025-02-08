//
//  Course.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Foundation
import SwiftData

@Model
final class Course {
    var id: String
    var title: String
    var desc: String
    var lessons: [Lesson]
    var progress: Double
    var deviceId: String
    
    init(id: String = UUID().uuidString,
         title: String,
         desc: String,
         deviceId: String = DeviceManager.shared.deviceId) {
        self.id = id
        self.title = title
        self.desc = desc
        self.lessons = []
        self.progress = 0.0
        self.deviceId = deviceId
    }
}
