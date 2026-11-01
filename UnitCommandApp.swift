import SwiftUI
import SwiftData

@main
struct UnitCommandApp: App {
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
        // تحديث قاعدة البيانات لتشمل كل النماذج الجديدة
        .modelContainer(for: [Soldier.self, Duty.self, Mission.self, Weapon.self, Ammo.self, Vehicle.self, DailyLog.self])
    }
}

struct MainAppView: View {
    @State private var isSplashActive = true
    
    var body: some View {
        ZStack {
            if isSplashActive {
                SplashView().transition(.opacity).zIndex(1)
            } else {
                ContentView().transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation(.easeInOut(duration: 0.8)) { self.isSplashActive = false }
            }
        }
    }
}

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem { Label("الرئيسية", systemImage: "square.grid.2x2.fill") }.tag(0)
            
            RosterView()
                .tabItem { Label("الأفراد", systemImage: "person.3.fill") }.tag(1)
            
            MedicalView()
                .tabItem { Label("الطبابة", systemImage: "cross.case.fill") }.tag(2)
            
            LogisticsView()
                .tabItem { Label("اللوجستيات", systemImage: "shield.lefthalf.filled") }.tag(3)
            
            OperationsView()
                .tabItem { Label("العمليات", systemImage: "calendar.badge.clock") }.tag(4)
            
            SalaryCalculatorView()
                .tabItem { Label("السلم", systemImage: "dollarsign.circle.fill") }.tag(5)
        }
        .tint(.green)
        .environment(\.layoutDirection, .rightToLeft)
    }
}
