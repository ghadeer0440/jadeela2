//
//  CalendarViewModel.swift
//  jadeela
//
//  Created by aisha rashid alshammari  on 18/05/1445 AH.
//
// CalendarViewModel.swift

// CalendarViewModel.swift
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
}

struct CalendarViewModel_Previews: PreviewProvider {
    static var previews: some View {
        tuggle()
    }
}


