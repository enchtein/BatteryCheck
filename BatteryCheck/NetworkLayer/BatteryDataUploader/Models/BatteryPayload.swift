//
//  BatteryPayload.swift
//  BatteryCheck
//
//  Created by Дмитрий Хероим on 07.08.2025.
//

import Foundation

struct BatteryPayload: Codable {
  let dateMs: Int64
  let battery: Int
  
  init(date: Date, percentage: Int) {
    dateMs = Int64(date.timeIntervalSince1970 * 1000)
    battery = percentage
  }
}
