//
//  jadeelaApp.swift
//  jadeela
//
//  Created by Ghadeer on 23/11/2023.
//

import SwiftUI

@main
struct jadeelaApp: App {
    @StateObject private var notificationManager = UserNotificationManager()

    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(notificationManager)
        }
        .modelContainer(for: TaskModel.self)
        .onChange(of: notificationManager.notificationAuthorizationStatus) { status in
            if status == .authorized {
                // Handle notification permission granted
            } else if status == .denied {
                // Handle notification permission denied
            }
        }
    }
}
