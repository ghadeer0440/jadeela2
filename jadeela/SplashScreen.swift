//
//  SplashScreen.swift
//  jadeela
//
//  Created by Ghadeer on 23/11/2023.
// test----
import SwiftUI

struct SplashScreen: View {
    @State var animate: Bool = false
    @State var showSplash: Bool = true
    @State private var showIntro: Bool = false // Set initial value to false

    var body: some View {
        ZStack {
            // Background
            Color(red: 142/255, green: 111/255, blue: 207/255) // Splash background color

            // Logo
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 500, height: 500)
                .padding(.leading, 15.0)
                .scaleEffect(animate ? 30 : 1) // Modify the scale factor to expand the image
                .animation(Animation.easeIn(duration: 2))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        animate.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showIntro.toggle() // Show the intro after the splash screen animation
                        }
                    }
                }
            
            
            
            
        }
        .edgesIgnoringSafeArea(.all)
        .opacity(showSplash ? 10 : 6) // Change opacity value
        .animation(.default)
        .background(Color.clear) // Clear background for ContentView
        .overlay(
            Group {
                if showIntro {
                    ContentView()
                }
            }
        )
    }
}

extension Color {
    init(hex: UInt) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}


struct splash_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
