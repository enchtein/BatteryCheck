//
//  BatteryDataUploader.swift
//  BatteryCheck
//
//  Created by Дмитрий Хероим on 07.08.2025.
//

import Foundation

final class BatteryDataUploader {
  static let shared = BatteryDataUploader()
  
  private init() {}
  
  func send(_ info: BatteryPayload) {
    guard let url = URL(string: "https://yourserver.com/battery") else {
      print("❌ Invalid URL")
      return
    }
    
    do {
      let jsonData = try JSONEncoder().encode(info)
      let base64String = jsonData.base64EncodedString()
      
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = base64String.data(using: .utf8)
      
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
          print("❌ Error sending battery data: \(error)")
        } else if let httpResponse = response as? HTTPURLResponse {
          print("✅ Battery data sent. Status code: \(httpResponse.statusCode)")
        }
      }
      
      task.resume()
    } catch {
      print("❌ Failed to encode JSON: \(error)")
    }
  }
}
