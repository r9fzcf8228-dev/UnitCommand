import SwiftUI
import SwiftData

@main
struct UnitCommandApp: App {
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
        .modelContainer(for: [Soldier.self, Duty.self, Mission.self])
    }
}

struct MainAppView: View {
    @State private var isSplashActive = true
    
    var body: some View {
        ZStack {
            if isSplashActive {
                SplashView()
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(1)
            } else {
                ContentView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    self.isSplashActive = false
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RosterView()
                .tabItem { Label("الأفراد", systemImage: "person.3.fill") }
                .tag(0)
            
            DutyRosterView()
                .tabItem { Label("المناوبات", systemImage: "calendar.badge.clock") }
                .tag(1)
            
            TasksView()
                .tabItem { Label("المهام", systemImage: "checklist") }
                .tag(2)
            
            SalaryCalculatorView()
                .tabItem { Label("السلم", systemImage: "dollarsign.circle.fill") }
                .tag(3)
            
            ReportsView()
                .tabItem { Label("التقارير", systemImage: "doc.text.fill") }
                .tag(4)
        }
        .tint(.green)
        .environment(\.layoutDirection, .rightToLeft)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedTab)
    }
}
