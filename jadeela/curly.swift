//
//  curly.swift
//  jadeela
//
//  Created by aisha rashid alshammari  on 18/05/1445 AH.
//
import SwiftUI

struct curly: View {
    var body: some View {
    
                ZStack{
                    Color(UIColor(hex: "FFFBF8"))
                        .ignoresSafeArea()
                VStack {
                    Text("Your hair type is:")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
                    
                    Text("Curly")
                        .padding()
                    
                    
                    
                    
                    Button("next") {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    }
                    
                    .frame(width: 200, height: 40)
                    .background(Color("button color"))
                    .padding(.bottom, 20.0)
                    .accessibilityAddTraits([.isButton])
                    .foregroundColor(.white)
                    
                    .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
                    
                    Image("curly")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400,height: 400)
                    
                        .padding(.top, 165.0)
                    
                    
                    
                    
                  
                }
                .padding(.top, 130.0)
                
            }
                
            }
        }
struct curly_Previews: PreviewProvider {
    static var previews: some View {
        curly()
    }
}

