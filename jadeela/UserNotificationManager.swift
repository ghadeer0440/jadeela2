//
//  UserNotificationManager.swift
//  jadeela
//
//  Created by Ghadeer on 04/12/2023.
//

import SwiftUI
import UserNotifications

class UserNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var notificationAuthorizationStatus: UNAuthorizationStatus?

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                self.notificationAuthorizationStatus = granted ? .authorized : .denied
            }
        }
    }

    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationAuthorizationStatus = settings.authorizationStatus
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
