//
//  Routine.swift
//  jadeela
//
//  Created by hessah aljarallah  on 28-11-2023.
//

import SwiftUI
import SwiftData
struct Routine: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var selectedDate: Date = Date()
    @State private var isBackTapped = false
    @State private var showingPopup = false
    @State private var isActive: Bool = false
    
    @State private var dates: Set<DateComponents> = []

    @Query var taskslist: [TaskModel]
    
    
    @State var currentTask = TaskModel(name: "", date: Date(), note: "")

    
    
    var body: some View {
        
//        NavigationView {
            
            ZStack {
                Color(UIColor(hex: "FFFBF8"))
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingPopup = false
                    }
                
                
                VStack {
                    
                    HStack (spacing: 26){
                        
                        NavigationLink(destination:tuggle()) {
                            
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
                        
                        
                        
                        
                        NavigationLink(destination:oil() ) {
                            
                            VStack {
                                
                                
                                Image("oil2")
                                    .resizable(resizingMode: .stretch)
                                    .foregroundColor(Color.white)
                                    .frame(width: 38.0, height: 36.0)
                                Text("Oil")
                                    .foregroundColor(.white)
                                
                                
                            }
                            
                            .frame(width: 60, height: 60)
                            .padding()
                            .background(Color(UIColor(hex: "8E6FCF")))
                            .cornerRadius(10)
                            
                            
                        }
                        .modelContainer(for: TaskModel.self)

                        
                        
                        NavigationLink(destination:cut() ) {
                            
                            VStack {
                                
                                
                                Image("cut")
                                    .resizable(resizingMode: .stretch)
                                    .foregroundColor(Color.white)
                                    .frame(width: 38.0, height: 36.0)
                                Text("Cut")
                                    .foregroundColor(.white)
                                
                                
                            }
                            
                            .frame(width: 60, height: 60)
                            .padding()
                            .background(Color(UIColor(hex: "8E6FCF")))
                            .cornerRadius(10)
                            
                            
                        }
                        
                        
                        
                    }
                    .padding(44)

                    //                    .offset(x:0 , y:-10)
                    //                    .padding(40)
                    //
                    //                     Spacer(minLength: -100)
                    
                    VStack(alignment: .leading){
                        Text("Calendar")
                            .offset(x:11, y:17)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                        //                           .padding(.leading, 20)
                        //                         .padding(.top, 20)
                        //                          .position(x: 80, y: -50)
                    
                       
                       
                       DatePicker("calendar", selection: $selectedDate)
                        .accentColor(Color(red: 0.556, green: 0.434, blue: 0.812))
                        .frame(width: 305.0)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding(.top, 10)
 
                    //                      .padding(.bottom, 150)
                    
                    
                        .onChange(of: selectedDate) { _ in
                            
                            for task in taskslist
                            {
                                
                                print("the Date in List \( chnageFormat(date:task.date))")
                                print("the Date in List \( chnageFormat(date:selectedDate))")

                                if chnageFormat(date: task.date) == chnageFormat(date: selectedDate)
                                {
                                    print("task selected !!!")
                                    showingPopup = true
                                    
                                    currentTask = task

                                }
                                else
                                {
                                    print("No task selected !!!")

                                }
                            }
                            
                            
                        }
                }
            }
            
                            
                            if showingPopup {
                                PopoverView(text: currentTask.name)
                                    .onTapGesture {
                                        showingPopup = false
                             
                        }
                }
            }
            .onAppear{
                
                addingDates()
            }
            
            
//        }
        .navigationBarBackButtonHidden(true)                .navigationBarTitle("Routine", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("Custom Action")
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                                .offset(x:-6 , y:0)
                        }
                    }
                }
            }
        
        

    }
    
    
    
        struct PopoverView: View {
            @State var text: String = "test"
            
            var body: some View {
                ZStack {
                    Rectangle()
                        .frame(width: 300, height: 100)
                        .foregroundColor(.white)
                       
                        .foregroundColor(Color(red: 0.906, green: 0.906, blue: 0.906))
                        .cornerRadius(10)
                        .overlay {
                            Text(text)
                                .foregroundColor(.black)
                        }
                    
                        .shadow(color:Color.black.opacity(0.2),radius: 5, x:0,y:5)
                }
                
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .position(x: 200, y: 400)
                
            }
            
        }
    
    
    
    func addingDates()
    {
        for task in taskslist {
            
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: task.date)
         
            dates.insert(dateComponents)
            
            print("the count of addingDates \(dates.count)")
            print("the date is \(task.date)")
        }
        
    }
    
    
    func addingDatetoList(task : TaskModel)
    {
            
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: task.date)
         
            dates.insert(dateComponents)
            
            print("the count of addingDates \(dates.count)")
            print("the date is \(task.date)")
        
        
    }
    
    
    func chnageFormat (date:Date) -> String
    {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy"
        let showDate = inputFormatter.date(from: "07/21/2016")
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let resultString = inputFormatter.string(from: date)
        
        return resultString
    }
    
    
    
    }
    struct Routine_Previews: PreviewProvider {
        static var previews: some View {
            Routine()
        }
    }
    




  
