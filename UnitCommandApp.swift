import SwiftUI
import SwiftData
import UIKit

@main
struct UnitCommandApp: App {
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
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
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.05, green: 0.08, blue: 0.05, alpha: 1.0)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem { Label("القيادة", systemImage: "target") }.tag(0)
            
            RosterView()
                .tabItem { Label("الأفراد", systemImage: "person.text.rectangle.fill") }.tag(1)
            
            MedicalView()
                .tabItem { Label("الطبابة", systemImage: "staroflife.fill") }.tag(2)
            
            LogisticsView()
                .tabItem { Label("اللوجستيات", systemImage: "archivebox.fill") }.tag(3)
            
            OperationsView()
                .tabItem { Label("العمليات", systemImage: "map.fill") }.tag(4)
            
            SalaryCalculatorView()
                .tabItem { Label("السلم", systemImage: "banknote.fill") }.tag(5)
        }
        .tint(.green)
        .environment(\.layoutDirection, .rightToLeft)
    }
}
