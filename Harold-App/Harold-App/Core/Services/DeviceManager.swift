//
//  DeviceManager.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Foundation

class DeviceManager {
    static let shared = DeviceManager()
    private init() {}
    
    var deviceId: String {
        if let existingId = UserDefaults.standard.string(forKey: "device_id") {
            return existingId
        }
        let newId = UUID().uuidString
        UserDefaults.standard.set(newId, forKey: "device_id")
        return newId
    }
    
    var lastSyncTimestamp: Date {
        get {
            UserDefaults.standard.object(forKey: "last_sync") as? Date ?? .distantPast
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "last_sync")
        }
    }
}
