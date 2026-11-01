import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var showText = false
    
    var body: some View {
        ZStack {
            // خلفية عسكرية فخمة (تدرج لوني داكن مع لمسة خضراء)
            LinearGradient(colors: [Color(red: 0.05, green: 0.1, blue: 0.05), Color(red: 0.1, green: 0.2, blue: 0.1)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // شعار التطبيق (درع) مع تأثير توهج وأنميشن تكبير
                Image(systemName: "shield.checkerboard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
                    .foregroundStyle(LinearGradient(colors: [.green, .mint], startPoint: .top, endPoint: .bottom))
                    .shadow(color: .green.opacity(0.8), radius: 30, x: 0, y: 0)
                    .scaleEffect(isAnimating ? 1.0 : 0.3)
                    .opacity(isAnimating ? 1.0 : 0.0)
                
                VStack(spacing: 8) {
                    // اسم التطبيق
                    Text("نظام إدارة الوحدة")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    
                    // اسم المبرمج (كما طلبت)
                    Text("تصميم وتطوير:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                    
                    Text("الملازم أول طبابة / منتظر يسر جبار")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(LinearGradient(colors: [.green, .teal], startPoint: .leading, endPoint: .trailing))
                }
                .opacity(showText ? 1 : 0)
                .offset(y: showText ? 0 : 20)
            }
        }
        .onAppear {
            // أنميشن نابض (Spring) عند بدء التشغيل
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
                self.isAnimating = true
            }
            // أنميشن ظهور النص بعد تأخير بسيط
            withAnimation(.easeInOut(duration: 1.2).delay(0.4)) {
                self.showText = true
            }
        }
    }
}
