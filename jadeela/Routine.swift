//
//  Routine.swift
//  jadeela
//
//  Created by hessah aljarallah  on 28-11-2023.
//

import SwiftUI

struct Routine: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var selectedDate: Date = Date()
    @State private var isBackTapped = false
    @State private var showingPopup = false
    
    var body: some View {
        //            NavigationView {
        ZStack {
            Color(UIColor(hex: "FFFBF8"))
                .ignoresSafeArea()
                .onTapGesture {
                    showingPopup = false
                }
            
            VStack {
                
                
                HStack(spacing: 26) {
                    Button(action: {
                        // Add action for the first button here
                    }) {
                        VStack {
                            Image("mask2")
                                .resizable(resizingMode: .stretch)
                                .foregroundColor(Color.white)
                                .frame(width: 38.0, height: 36.0)
                            Text("Mask")
                                .foregroundColor(.white)
                        }
                        .frame(width: 60, height: 60)
                        .padding()
                        .background(Color(UIColor(hex: "8E6FCF")))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        // Add action for the second button here
                    }) {
                        VStack {
                            Image("oil2")
                                .resizable(resizingMode: .stretch)
                                .foregroundColor(Color(hue: 1.0, saturation: 0.025, brightness: 0.972))
                                .frame(width: 38.0, height: 36.0)
                            Text("Oil")
                                .foregroundColor(.white)
                        }
                        .frame(width: 60, height: 60)
                        .padding()
                        .background(Color(UIColor(hex: "8E6FCF")))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        // Add action for the third button here
                    }) {
                        VStack {
                            Image("cut")
                                .resizable(resizingMode: .stretch)
                                .foregroundColor(Color(hue: 1.0, saturation: 0.025, brightness: 0.972))
                                .frame(width: 38.0, height: 36.0)
                            Text("Cut")
                                .foregroundColor(.white)
                        }
                        .frame(width: 60, height: 60)
                        .padding()
                        .background(Color(UIColor(hex: "8E6FCF")))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
         .padding(.bottom, 100)
                .buttonStyle(PlainButtonStyle())
                
               // Spacer(minLength: -100)

                VStack(alignment: .leading){
                    Text("calendar")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    //   .padding(.leading, 20)
                    // .padding(.top, 20)
                    //  .position(x: 80, y: -50)
                    
                    DatePicker("calendar", selection: $selectedDate)
                        .accentColor(Color(red: 0.556, green: 0.434, blue: 0.812))
                        .frame(width: 305.0)
                        .datePickerStyle(GraphicalDatePickerStyle())
                      //  .padding(.top, 10)
                        //.padding(.bottom, 150)
                    
                        .onChange(of: selectedDate) { _ in
                            showingPopup = true
                        }
                }
            }
            
            if showingPopup {
                PopoverView(text: "test")
                    .onTapGesture {
                        showingPopup = false
                    }
            }
            //                }

        }                .navigationBarTitle("Routine", displayMode: .inline)

    }
}
        struct PopoverView: View {
            @State var text: String = "test"

            var body: some View {
                ZStack {
                    Rectangle()
                        .frame(width: 300, height: 100)
                        .foregroundColor(.white)
                        .shadow(color:Color.black.opacity(0.2),radius: 5, x:0,y:5)
                       // .foregroundColor(Color(red: 0.906, green: 0.906, blue: 0.906))
                        .cornerRadius(10)
                        .overlay {
                            Text(text)
                                .foregroundColor(.black)
                        }
                    
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .position(x: 200, y: 400)

            }
        }
    

//    struct ContentView_Previews: PreviewProvider {
//        static var previews: some View {
//           ContentView()
//        }
//    }
        
        
        
    
        #Preview {
            Routine()
        }
        






  
