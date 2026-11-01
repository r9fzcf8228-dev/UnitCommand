import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query private var soldiers: [Soldier]
    @Query private var missions: [Mission]
    @Query private var vehicles: [Vehicle]
    @Query private var weapons: [Weapon]
    
    @State private var showPulse = false
    @State private var appear = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // خلفية عسكرية متدرجة
                LinearGradient(colors: [Color(red: 0.05, green: 0.1, blue: 0.05), Color.black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // الشعار والاسم
                        VStack(spacing: 10) {
                            Image(systemName: "shield.checkerboard")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.green)
                                .shadow(color: .green.opacity(0.8), radius: 20)
                                .scaleEffect(showPulse ? 1.05 : 0.95)
                                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: showPulse)
                            
                            Text("مركز القيادة والسيطرة")
                                .font(.system(size: 24, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("الملازم أول طبابة / منتظر يسر جبار")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        .padding(.top, 20)
                        
                        // بطاقات الإحصائيات
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            StatCard(title: "إجمالي الأفراد", value: "\(soldiers.count)", icon: "person.3.fill", color: .blue)
                            StatCard(title: "الأفراد الحاضرون", value: "\(soldiers.filter { $0.status == "حاضر" }.count)", icon: "checkmark.shield.fill", color: .green)
                            StatCard(title: "المهام المعلقة", value: "\(missions.filter { !$0.isCompleted }.count)", icon: "list.bullet.clipboard.fill", color: .orange)
                            StatCard(title: "الآليات الجاهزة", value: "\(vehicles.filter { $0.status == "جاهزة" }.count)", icon: "car.fill", color: .purple)
                            StatCard(title: "الأسلحة", value: "\(weapons.count)", icon: "scope", color: .red)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                showPulse = true
                withAnimation(.easeOut(duration: 0.8)) {
                    appear = true
                }
            }
        }
    }
}

struct StatCard: View {
    var title: String
    var value: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            HStack {
                Image(systemName: icon).font(.title2).foregroundColor(color).shadow(color: color.opacity(0.5), radius: 5)
                Spacer()
            }
            Text(value).font(.system(size: 34, weight: .heavy, design: .rounded)).foregroundColor(.white)
            Text(title).font(.caption).foregroundColor(.gray)
        }
        .padding()
        // تصميم زجاجي عسكري
        .background(Color(red: 0.1, green: 0.15, blue: 0.1).opacity(0.8))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20).stroke(color.opacity(0.4), lineWidth: 1)
        )
        .shadow(color: color.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}
