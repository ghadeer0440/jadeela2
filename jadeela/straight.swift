//
//  straight.swift
//  jadeela
//
//  Created by aisha rashid alshammari  on 18/05/1445 AH.
//

import SwiftUI

struct straight: View {
    @State private var navigateToRoutine = false
    
    var body: some View {

            ZStack {
                Color(UIColor(hex: "FFFBF8"))
                    .ignoresSafeArea()
                VStack {
                    Text("Your hair type is:")
                        .font(.system(size: 32))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .padding(.top, 200)
                    
                    Text("Straight")
                        .font(.system(size: 24))
                        .padding(.top, -5)
                    
                    NavigationLink(
                        destination: Routine(),
                        isActive: $navigateToRoutine,
                        label: {
                            Text("Next")
                                .foregroundColor(.white)
                                .frame(width: 200, height: 20)
                                .padding()
                                .background(Color(UIColor(hex: "8E6FCF")))
                                .cornerRadius(10)
                                .onTapGesture {
                                    navigateToRoutine = true
                                }
                        })
                        .padding(.top, 60)
                        .padding(.bottom, 60.0)
                    
                    Image("straight")
                        .resizable()
                        .frame(width: 400, height: 400)
                        .padding(.bottom, 90.0)
                }
                .padding(.top, 90.0)
            }
        
    }
}

struct straight_Previews: PreviewProvider {
    static var previews: some View {
        straight()
    }
}

