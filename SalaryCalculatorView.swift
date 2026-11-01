import SwiftUI

struct SalaryCalculatorView: View {
    @State private var selectedRank = "جندي"
    @State private var years = 0

    let ranks = ["جندي", "جندي أول", "نائب عريف", "عريف", "رئيس عرفاء", "ملازم", "ملازم أول", "نقيب", "رائد", "مقدم", "عقيد"]

    var body: some View {
        NavigationStack {
            Form {
                Section("بيانات الفرد") {
                    Picker("الرتبة", selection: $selectedRank) {
                        ForEach(ranks, id: \.self) { Text($0) }
                    }
                    Stepper("سنوات الخدمة: \(years)", value: $years, in: 0...40)
                }

                Section("النتائج التقريبية") {
                    let base = SalaryCalculator.calculateBaseSalary(rank: selectedRank, yearsOfService: years)
                    let eos = SalaryCalculator.calculateEndOfService(rank: selectedRank, yearsOfService: years)

                    HStack {
                        Text("الراتب الأساسي")
                        Spacer()
                        Text("\(Int(base)) د.ع").bold()
                    }
                    HStack {
                        Text("مستحقات نهاية الخدمة")
                        Spacer()
                        Text("\(Int(eos)) د.ع").bold()
                    }
                }

                Section {
                    Text("ملاحظة: هذه الحسابات تقريبية وتعتمد على المعاملات الافتراضية. عدّل دالة `SalaryCalculator` لتطابق سلم الرواتب الرسمي لوحدتك.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("حاسبة السلم")
        }
    }
}
