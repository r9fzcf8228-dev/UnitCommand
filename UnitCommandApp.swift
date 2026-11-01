
import SwiftUI
import SwiftData

@main
struct UnitCommandApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Soldier.self, Duty.self, Mission.self])
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            RosterView()
                .tabItem { Label("الأفراد", systemImage: "person.3.fill") }
            DutyRosterView()
                .tabItem { Label("المناوبات", systemImage: "calendar.badge.clock") }
            TasksView()
                .tabItem { Label("المهام", systemImage: "checklist") }
            SalaryCalculatorView()
                .tabItem { Label("السلم", systemImage: "dollarsign.circle") }
            ReportsView()
                .tabItem { Label("التقارير", systemImage: "doc.text.fill") }
        }
        .environment(\.layoutDirection, .rightToLeft) // واجهة عربية
    }
}
