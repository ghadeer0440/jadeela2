//
//  cut.swift
//  jadeela
//
//  Created by aisha rashid alshammari  on 18/05/1445 AH.
//

import SwiftUI
import SwiftData
struct cut: View {
    @Environment(\.presentationMode) var presentationMode
    @Query var taskslist: [TaskModel]
    @State private var tasks: [Task] = []
    @State private var showingAddTask = false
    @State private var selectedOption: String = ""
    let exampleColor: Color = (Color(red: 1.0, green: 0.984, blue: 0.975))

    var body: some View {
//        NavigationView {
            VStack {
                
                 List {
                    // ForEach(tasks.indices, id: \.self) { index in
                         
                         ForEach(tasks.indices, id: \.self) { index in

                         Task2Row(task: $tasks[index])
                     }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
                Button(action: {
                    self.showingAddTask = true
                }) {
                    Text("Add cut")
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 0.538, green: 0.46, blue: 0.711))
                        .padding()
                        .offset(x: -35, y: 0)

                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .offset(x: -175, y: 0)
                            .font(.headline)
                            .bold()
                            .foregroundColor(Color(red: 0.538, green: 0.46, blue: 0.711))
                    }
                }
            }
            .navigationBarItems(trailing: menuButton)
            .navigationBarTitle("Cut", displayMode: .inline)
            .background(Color(red: 1.0, green: 0.984, blue: 0.975))
            .background(exampleColor)
            .scrollContentBackground(.hidden)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
//        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    print("Custom Action")
                    presentationMode.wrappedValue.dismiss()

                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .offset(x:-8 , y:0)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTask2View(isShowing: $showingAddTask) { task in
                self.tasks.append(task)
                // Save tasks to UserDefaults whenever it changes
                saveTasksToUserDefaults()
            }
        }
        // Load tasks from UserDefaults when the view appears
        .onAppear {
            loadTasksFromUserDefaults()
        }
    }
    private var menuButton: some View {
        Menu {
            Button(role: .destructive, action: {
                selectedOption = ""
                tasks.removeAll()
            }) {
                Label("Delete All", systemImage: "trash")
                    .foregroundColor(.red)
            }
        } label: {
            Label(selectedOption, systemImage: "ellipsis.circle")
                .foregroundColor(Color(red: 0.537, green: 0.46, blue: 0.711))
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
        // Save tasks to UserDefaults whenever it changes
        saveTasksToUserDefaults()
    }

    func delete(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        // Save tasks to UserDefaults whenever it changes
        saveTasksToUserDefaults()
    }

    // Save tasks to UserDefaults
    private func saveTasksToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "cut_tasks")
        }
    }

    // Load tasks from UserDefaults
    private func loadTasksFromUserDefaults() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "cut_tasks"),
           let decodedTasks = try? decoder.decode([Task].self, from: data) {
            self.tasks = decodedTasks
        }
    }
}


struct task2: Identifiable, Codable {
    var id = UUID()
    var name: String
    var dueDate: Date
    var completed: Bool = false
    var noteName: String = ""
}

        struct Task2Row: View {
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
        struct EditTask2View: View {
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
                        TextField("cut", text: $editedTaskName)
                            .font(.headline)
                            .padding()
                           
                        
                        TextField("Note", text: $editedNoteName)
                            .font(.headline)
                            .padding()
                        
                        DatePicker("", selection: $editedDueDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                            

                    }
                    
                    .navigationBarTitle("Edit cut", displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        task.name = editedTaskName
                        task.noteName = editedNoteName
                        task.dueDate = editedDueDate
                        isEditing = false
                    }) {
                        Text("Save")
                            .foregroundColor(Color(red: 0.538, green: 0.46, blue: 0.711))
                        
                    })
                    .tint(Color(UIColor(hex: "8E6FCF")))

                }
            }
        }


        struct AddTask2View: View {
            @Environment(\.presentationMode) var presentationMode
            @Environment(\.modelContext) var modelContext
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
                        TextField("cut", text: $taskName)
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
                    
                    .navigationBarTitle("Add Cut", displayMode: .inline)
                    .navigationBarItems(leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(Color(red: 0.538, green: 0.46, blue: 0.711))
                    }, trailing: Button(action: {
                        let task = Task(name: self.taskName, dueDate: self.dueDate, noteName: self.noteName )
                        self.saveTask(task)
                        self.presentationMode.wrappedValue.dismiss()
                        
                        let currentTask = TaskModel(name: self.taskName, date: self.dueDate , note:  self.noteName)
                        
                        modelContext.insert(currentTask)

                        
                        try? modelContext.save()

                        
                    }) {
                        Text("Save")
                            .foregroundColor(Color(red: 0.538, green: 0.46, blue: 0.711))
                    })
                    .background(exampleColor)
                    .scrollContentBackground(.hidden)
                    .tint(Color(UIColor(hex: "8E6FCF")))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
            }
        }


        struct cut_Previews: PreviewProvider {
            static var previews: some View {
                cut()
            }
        }
