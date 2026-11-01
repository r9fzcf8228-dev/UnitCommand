struct ContentView: View {
    @State private var selectedTab = 0
    
    // تغيير لون شريط التبويبات ليكون داكناً
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
        .tint(.green) // لون التحديد
        .environment(\.layoutDirection, .rightToLeft)
    }
}
