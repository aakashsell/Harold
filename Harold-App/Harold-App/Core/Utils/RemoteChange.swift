//
//  RemoteChange.swift
//  Harold-App
//
//  Created by Luke Cusato on 2/8/25.
//

import SwiftUI

// Assuming RemoteChange represents a change from the remote server
struct RemoteChange {
    let deviceId: String
    // Add other properties that represent the change from the remote system
    let changeId: String
    let data: [String: Any] // This could be the actual data of the change
}

// Assuming LocalChange represents a change from the local device


//#Preview {
//    RemoteChange()
//}
