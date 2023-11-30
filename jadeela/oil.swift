//
//  oil.swift
//  jadeela
//
//  Created by Diyam Alrabah on 16/05/1445 AH.
//

import SwiftUI

struct oil: View {
    @Environment(\.presentationMode) var presentationMode
      
            @State private var tasks: [Task] = []
            @State private var showingAddTask1 = false
            let exampleColor : Color = (Color(red: 1.0, green: 0.984, blue: 0.975))
            var body: some View {
                NavigationView {
                    VStack {
                        List {
                            ForEach(tasks.indices, id: \.self) { index in
                                Task1Row(task: $tasks[index])
                                
                            }
                            .onMove(perform: move)
                            .onDelete(perform: delete)
                        }
                        Button(action: {
                            self.showingAddTask1 = true
                        }) {
                            Text("Add oil")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.538, green: 0.46, blue: 0.711))
                                .padding()
                                .offset(x: -35, y: 0)
                       
                            HStack {
                        Image(systemName: "plus.circle.fill")
                                    .offset(x: -160, y: 0)

                                    .font(.headline)
                .bold()
            .foregroundColor(Color(red: 0.538, green: 0.46, blue: 0.711))
                                            }

                        }
                    }
                    .navigationBarTitle("Oil",displayMode: .inline)
                    .background(Color(red: 1.0, green: 0.984, blue: 0.975))
                    .background(exampleColor)
                    .scrollContentBackground(.hidden)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                .navigationBarBackButtonHidden(true)                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            print("Custom Action")
                            presentationMode.wrappedValue.dismiss()
                                
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                                    .offset(x:15 , y:0)
                            }
                        }
                    }
                }

                

                .sheet(isPresented: $showingAddTask1) {
                    AddTask1View(isShowing: $showingAddTask1) { task in
                        self.tasks.append(task)
                        
                    }
                }
            }
            
            func move(from source: IndexSet, to destination: Int) {
                tasks.move(fromOffsets: source, toOffset: destination)
            }
            
            func delete(at offsets: IndexSet) {
                tasks.remove(atOffsets: offsets)
            }
        }

        import SwiftUI

        struct Task1: Identifiable {
            let id = UUID()
            var name: String
            var dueDate: Date
            var completed: Bool = false
            var noteName: String = ""
        }

        struct Task1Row: View {
            @Binding var task: Task
            @State private var isEditing = false
            
            var body: some View {
                VStack {
                    HStack {
                        Image(systemName: task.completed ? "checkmark.circle" : "circle")
                            .foregroundColor(task.completed ? Color.purple : Color.primary)
                            .offset(x: 5, y: -1)
                            .onTapGesture {
                                self.task.completed.toggle()
                                
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(task.name)
                                    .font(.headline)
                                    .foregroundColor(task.completed ? Color.gray : Color.primary)
                                
                                Spacer()
                                
                                Button(action: {
                                    isEditing.toggle()
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(Color.primary)
                                        .offset(x: 5, y: 19)
                                }
                                .sheet(isPresented: $isEditing) {
                                    EditTaskView(task: $task, isEditing: $isEditing)
                                }
                            }
                            
                            if !task.noteName.isEmpty {
                                Text(task.noteName)
                                    .font(.subheadline)
                                    .foregroundColor(Color.secondary)
                            }
                            
                            Text(task.dueDate, style: .date)
                                .font(.subheadline)
                                .foregroundColor(Color.secondary)
                            
                        }
                    }
                    .padding()

                }
            }
        }
        struct EditTask1View: View {
            @Binding var task: Task
            @Binding var isEditing: Bool
            @State private var editedTaskName: String
            @State private var editedNoteName: String
            @State private var editedDueDate: Date
            
            init(task: Binding<Task>, isEditing: Binding<Bool>) {
                _task = task
                _isEditing = isEditing
                _editedTaskName = State(initialValue: task.wrappedValue.name)
                _editedNoteName = State(initialValue: task.wrappedValue.noteName)
                _editedDueDate = State(initialValue: task.wrappedValue.dueDate)
            }
            
            var body: some View {
                NavigationView {
                    Form {
                        TextField("Oil", text: $editedTaskName)
                            .font(.headline)
                            .padding()
                           
                        
                        TextField("Note", text: $editedNoteName)
                            .font(.headline)
                            .padding()
                        
                        DatePicker("", selection: $editedDueDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                            

                    }
                    
                    .navigationBarTitle("Edit Oil", displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        task.name = editedTaskName
                        task.noteName = editedNoteName
                        task.dueDate = editedDueDate
                        isEditing = false
                    }) {
                        Text("Save")
                            .foregroundColor(Color(red: 0.538, green: 0.46, blue: 0.711))
                        
                    })
                    .tint(.purple)

                }
            }
        }


        struct AddTask1View: View {
            @Environment(\.presentationMode) var presentationMode
            @State private var taskName: String = ""
            @State private var noteName: String = ""
            @State private var dueDate: Date = Date()
            @State private var showCalendar = false
            @State private var selectedDate = Date()
            let exampleColor : Color = (Color(red: 1.0, green: 0.984, blue: 0.975))

            var isShowing: Binding<Bool>
            var saveTask: (Task) -> Void

            var body: some View {
                NavigationView {
                    Form {
                        TextField("Oil", text: $taskName)
                            .font(.headline)
                            .padding()
                           
                        TextField("Note", text: $noteName)
                            .font(.headline)
                            .padding()
                        
                        Toggle(isOn: $showCalendar) {
                            Text("Show Calendar")
                              
                            
                        }
                       
                        .padding()
                        
                        if showCalendar {
                            DatePicker("", selection: $dueDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                            
                        }
                        
                    }
                    
                    .navigationBarTitle("Add Oil", displayMode: .inline)
                    .navigationBarItems(leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(Color(red: 0.538, green: 0.46, blue: 0.711))
                    }, trailing: Button(action: {
                        let task = Task(name: self.taskName, dueDate: self.dueDate, noteName: self.noteName )
                        self.saveTask(task)
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                            .foregroundColor(Color(red: 0.538, green: 0.46, blue: 0.711))
                    })
                    .background(exampleColor)
                    .scrollContentBackground(.hidden)
                    .tint(.purple)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
            }
        }


        struct oil_Previews: PreviewProvider {
            static var previews: some View {
                oil()
            }
        }

