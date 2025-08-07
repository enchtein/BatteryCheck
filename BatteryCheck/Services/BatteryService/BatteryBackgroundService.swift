//
//  BatteryBackgroundService.swift
//  BatteryCheck
//
//  Created by Дмитрий Хероим on 07.08.2025.
//

import SwiftUI
import CoreLocation

class BatteryBackgroundService: NSObject {
  static let shared = BatteryBackgroundService()
  
  private let locationManager = CLLocationManager()
  private var timer: Timer?
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
  }
  
  func startUsageTrigger() {
    //do nothing
    //use just for initialize service
  }
  
  private func start() {
    // Запуск GPS — держит приложение в фоне
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.pausesLocationUpdatesAutomatically = false
    locationManager.startUpdatingLocation()
    
    performBatteryCheck() //Immediately check and process battare state
    startTimer()
  }
  
  private func stop() {
    timer?.invalidate()
    timer = nil
    locationManager.stopUpdatingLocation()
  }
  
  private func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { _ in
      self.performBatteryCheck()
    }
    RunLoop.current.add(timer!, forMode: .common)
  }
  
  private func performBatteryCheck() {
    UIDevice.current.isBatteryMonitoringEnabled = true
    
    let date = Date() //zero timezone
    let level = UIDevice.current.batteryLevel
    let percentage = Int(level * 100)
    
    print("BatteryBackgroundService: ")
    print("⌛️ date = \(date)")
    print("🔋 percentage = \(percentage)")
    print("--------------------------------------------")
    
#if targetEnvironment(simulator)
    print("⚠️ No reason for send data in simulator")
#else
    let payload = BatteryPayload(date: date, percentage: percentage)
    BatteryDataUploader.shared.send(payload)
#endif
  }
}

//MARK: - CLLocationManagerDelegate
extension BatteryBackgroundService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // just stay in backgorund
  }
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedAlways:
      print("✅ Доступ разрешён всегда")
      start()
    case .authorizedWhenInUse:
      print("✅ Доступ разрешён при использовании")
      start()
    case .denied:
      print("❌ Доступ запрещён")
    case .notDetermined:
      print("❓ Разрешение не определено")
    case .restricted:
      print("🚫 Доступ ограничен")
    @unknown default:
      break
    }
  }
}
