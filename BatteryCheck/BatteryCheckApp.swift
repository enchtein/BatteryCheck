//
//  BatteryCheckApp.swift
//  BatteryCheck
//
//  Created by Дмитрий Хероим on 07.08.2025.
//

import SwiftUI

@main
struct BatteryCheckApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear {
          BatteryBackgroundService.shared.startUsageTrigger()
        }
    }
  }
}
