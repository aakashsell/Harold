//
//  APIClient.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Foundation

actor APIClient {
    static let shared = APIClient()
    private let baseURL = URL(string: "your-api-url")!
    private let deviceId = DeviceManager.shared.deviceId
    
    struct APIError: Error {
        let message: String
        let code: Int
    }
    
    private var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "X-Device-ID": deviceId,
            "Accept": "application/json"
        ]
    }
    
    // Ensure RemoteChange conforms to Decodable
    struct RemoteChange: Decodable {
        let deviceId: String
        let changeDetails: String  // Replace with actual fields
    }
    
    // Ensure LocalChange conforms to Encodable
    struct LocalChange: Encodable {
        let deviceId: String
        let changeDetails: String  // Replace with actual fields
    }
    
    func fetchChanges(since date: Date) async throws -> [RemoteChange] {
        var components = URLComponents(url: baseURL.appendingPathComponent("changes"), resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "since", value: ISO8601DateFormatter().string(from: date))
        ]
        
        var request = URLRequest(url: components.url!)
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError(message: "Invalid response", code: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        return try JSONDecoder().decode([RemoteChange].self, from: data)
    }
    
    func pushChanges(_ changes: [LocalChange]) async throws {
        var request = URLRequest(url: baseURL.appendingPathComponent("sync"))
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try JSONEncoder().encode(changes)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError(message: "Failed to push changes", code: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
    }
}
