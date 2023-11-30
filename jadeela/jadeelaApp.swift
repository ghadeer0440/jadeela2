//
//  jadeelaApp.swift
//  jadeela
//
//  Created by Ghadeer on 23/11/2023.
//

import SwiftUI

@main
struct jadeelaApp: App {
    private var delegate: NotificationDelegate = NotificationDelegate()
             
             init() {
                 let center = UNUserNotificationCenter.current()
                 center.delegate = delegate
                 center.requestAuthorization (options: [.alert, .sound, .badge]) { result, error in
                     if let error = error {
                         print(error)
                     }
                 }
             }
    var body: some Scene {
        WindowGroup {
            SplashScreen()
            localNotification()

        }
    }
}
