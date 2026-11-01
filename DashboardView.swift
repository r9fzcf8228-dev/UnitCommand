import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query private var soldiers: [Soldier]
    @Query private var missions: [Mission]
    @Query private var vehicles: [Vehicle]
    
    @State private var showPulse = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // خلفية متدرجة فخمة
                LinearGradient(colors: [Color(red: 0.05, green: 0.1, blue: 0.05), Color.black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // ترحيب
                        VStack(alignment: .trailing, spacing: 5) {
                            Text("مركز القيادة")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                            Text("الملازم أول طبابة / منتظر يسر جبار")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        // بطاقات الإحصائيات الزجاجية
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            StatCard(title: "الأفراد", value: "\(soldiers.count)", icon: "person.3.fill", color: .blue)
                            
                            StatCard(title: "الحاضرون", value: "\(soldiers.filter { $0.status == "حاضر" }.count)", icon: "checkmark.shield.fill", color: .green)
                            
                            StatCard(title: "المهام المعلقة", value: "\(missions.filter { !$0.isCompleted }.count)", icon: "list.bullet.clipboard.fill", color: .orange)
                            
                            StatCard(title: "الآليات الجاهزة", value: "\(vehicles.filter { $0.status == "جاهزة" }.count)", icon: "car.fill", color: .purple)
                        }
                        .padding(.horizontal)
                        
                        // شعار متحرك في الأسفل
                        Image(systemName: "shield.checkerboard")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.green.opacity(0.3))
                            .scaleEffect(showPulse ? 1.1 : 0.9)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: showPulse)
                            .padding(.top, 40)
                            .onAppear { showPulse = true }
                    }
                }
            }
            .navigationBarHidden(true)
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
                Image(systemName: icon).font(.title2).foregroundColor(color)
                Spacer()
            }
            Text(value).font(.system(size: 36, weight: .heavy, design: .rounded)).foregroundColor(.white)
            Text(title).font(.caption).foregroundColor(.gray)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20).stroke(color.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: color.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}
