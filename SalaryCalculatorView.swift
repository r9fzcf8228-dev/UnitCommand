import SwiftUI

// هذا الجزء يمثل الشاشة التي يراها المستخدم (الأزرار والقوائم)
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
            }
            .navigationTitle("حاسبة السلم")
        }
    }
}

// وهذا الجزء هو "المعادلات" التي قمنا بدمجها في نفس الملف
struct SalaryCalculator {
    static func calculateBaseSalary(rank: String, yearsOfService: Int) -> Double {
        let base: Double
        switch rank {
        case "جندي": base = 400_000
        case "جندي أول": base = 450_000
        case "نائب عريف": base = 500_000
        case "عريف": base = 550_000
        case "رئيس عرفاء": base = 650_000
        case "ملازم": base = 800_000
        case "ملازم أول": base = 900_000
        case "نقيب": base = 1_000_000
        case "رائد": base = 1_200_000
        case "مقدم": base = 1_400_000
        case "عقيد": base = 1_600_000
        default: base = 400_000
        }
        return base + (Double(yearsOfService) * 10_000)
    }

    static func calculateEndOfService(rank: String, yearsOfService: Int) -> Double {
        let monthly = calculateBaseSalary(rank: rank, yearsOfService: yearsOfService)
        return monthly * Double(yearsOfService) * 0.5
    }
}
