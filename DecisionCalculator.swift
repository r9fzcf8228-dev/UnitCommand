import Foundation

struct SalaryCalculator {
    // يمكنك تعديل هذه القيم وفقًا لسلم الرواتب الفعلي المعتمد لديك
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
        let incrementPerYear: Double = 10_000
        return base + (Double(yearsOfService) * incrementPerYear)
    }

    // حساب تقريبي للمستحقات (مثال: نهاية الخدمة)
    static func calculateEndOfService(rank: String, yearsOfService: Int) -> Double {
        let monthly = calculateBaseSalary(rank: rank, yearsOfService: yearsOfService)
        return monthly * Double(yearsOfService) * 0.5 // معامل تقريبي، عدله حسب القانون
    }
}
