//
//  SyncService.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

//import SwiftData
//import Foundation
//
//actor SyncService {
//    static let shared = SyncService()
//    private let api = APIClient.shared
//    private let deviceId = DeviceManager.shared.deviceId
//    
//    enum SyncError: Error {
//        case networkError
//        case mergeConflict
//        case invalidData
//    }
//    
//    func syncPlants(context: ModelContext) async throws {
//        // Fetch remote changes
//        let lastSync = DeviceManager.shared.lastSyncTimestamp
//        let remoteChanges = try await api.fetchChanges(since: lastSync)
//        
//        // Apply remote changes
//        for change in remoteChanges {
//            if change.deviceId != deviceId {
//                try await applyRemoteChange(change, in: context)
//            }
//        }
//        
//        // Push local changes
//        let localChanges = try await getLocalChanges(context)
//        try await api.pushChanges(localChanges)
//        
//        DeviceManager.shared.lastSyncTimestamp = Date()
//    }
//    
//    private func applyRemoteChange(_ change: RemoteChange, in context: ModelContext) async throws {         // Error msg: "Cannot find type 'RemoteChange' in scope"
//        // Implement merge logic
//    }
//    
//    private func getLocalChanges(_ context: ModelContext) async throws -> [LocalChange] {       // Error msg: "Cannot find type 'LocalChange' in scope"
//        // Get changes since last sync
//        return []
//    }
//}

//
//  SyncService.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import SwiftData
import Foundation

actor SyncService {
    static let shared = SyncService()
    private let api = APIClient.shared
    private let deviceId = DeviceManager.shared.deviceId
    
    enum SyncError: Error {
        case networkError
        case mergeConflict
        case invalidData
    }
    
    func syncPlants(context: ModelContext) async throws {
        // Fetch remote changes
        let lastSync = DeviceManager.shared.lastSyncTimestamp
        let remoteChanges = try await api.fetchChanges(since: lastSync)
        
        // Apply remote changes
        for change in remoteChanges {
            if change.deviceId != deviceId {
                try await applyRemoteChange(change, in: context)
            }
        }
        
        // Push local changes
        let localChanges = try await getLocalChanges(context)
        try await api.pushChanges(localChanges)
        
        DeviceManager.shared.lastSyncTimestamp = Date()
    }
    
    private func applyRemoteChange(_ change: RemoteChange, in context: ModelContext) async throws {
        // Implement merge logic based on the change structure
        // For example, you could update the context with the new data
        // context.update(change)
    }
    
    private func getLocalChanges(_ context: ModelContext) async throws -> [LocalChange] {
        // Get changes since last sync
        let localChanges: [LocalChange] = [] // Example, replace with your logic to get local changes
        return localChanges
    }
}



